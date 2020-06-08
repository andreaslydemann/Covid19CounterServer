import Vapor

struct InfectionController: RouteCollection {
    func boot(router: Router) throws {
        let infectionRouter = router.grouped("infections")
        
        infectionRouter.get("", Int.parameter, use: getInfectionsOfCountry)
        infectionRouter.post(ChangeInfectionRequest.self, at: "increment", use: incrementInfections)
        infectionRouter.post(ChangeInfectionRequest.self, at: "decrement", use: decrementInfections)
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
    
    func incrementInfections(_ req: Request, changeInfectionRequest: ChangeInfectionRequest) throws -> Future<HTTPStatus> {
        return try updateInfections(req, countryCode: changeInfectionRequest.countryCode, modification: .increment)
    }
    
    func decrementInfections(_ req: Request, changeInfectionRequest: ChangeInfectionRequest) throws -> Future<HTTPStatus> {
        return try updateInfections(req, countryCode: changeInfectionRequest.countryCode, modification: .decrement)
    }
    
    // MARK: Private Helpers
    private func updateInfections(_ req: Request, countryCode: Int, modification: Modification) throws -> Future<HTTPStatus> {
        let repository = try req.make(InfectionRepository.self)
        return repository.find(by: countryCode, on: req).map { infection -> Future<Infection> in
            let count = modification == .increment ? infection.count + 1 : infection.count - 1
            let updatedInfection = Infection(id: infection.id, count: count, countryCode: infection.countryCode)
            return repository.save(infection: updatedInfection, on: req)
        }.transform(to: .ok)
    }
    
    private enum Modification {
        case increment
        case decrement
    }
}
