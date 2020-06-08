import Vapor

struct InfectionController: RouteCollection {
    func boot(router: Router) throws {
        let infectionRouter = router.grouped("infections")
        
        infectionRouter.get("", use: getInfectionsOfCountry)
        infectionRouter.post(ChangeInfectionRequest.self, at: "increment", use: incrementInfectionCount)
        infectionRouter.post(ChangeInfectionRequest.self, at: "decrement", use: decrementInfectionCount)
    }
}

private extension InfectionController {
    func getInfectionsOfCountry(_ req: Request) throws -> Future<InfectionResponse> {
        let repository = try req.make(InfectionRepository.self)
        let countryCode = try req.parameters.next(Int.self)
        return repository.find(by: countryCode, on: req).map { infection in
            guard let infection = InfectionResponse(infection: infection, countryCode: countryCode) else {
                throw Abort(.notFound)
            }
            
            return infection
        }
    }
    
    func incrementInfectionCount(_ req: Request, changeInfectionRequest: ChangeInfectionRequest) throws -> Future<HTTPStatus> {
        let repository = try req.make(InfectionRepository.self)
        return repository.find(by: changeInfectionRequest.countryCode, on: req).map { infection -> Future<Infection> in
            let updatedInfection = Infection(id: infection.id, count: infection.count + 1, countryCode: infection.countryCode)
            return repository.save(infection: updatedInfection, on: req)
        }.transform(to: .ok)
    }
    
    func decrementInfectionCount(_ req: Request, changeInfectionRequest: ChangeInfectionRequest) throws -> Future<HTTPStatus> {
        let repository = try req.make(InfectionRepository.self)
        return repository.find(by: changeInfectionRequest.countryCode, on: req).map { infection -> Future<Infection> in
            let updatedInfection = Infection(id: infection.id, count: infection.count - 1, countryCode: infection.countryCode)
            return repository.save(infection: updatedInfection, on: req)
        }.transform(to: .ok)
    }
}
