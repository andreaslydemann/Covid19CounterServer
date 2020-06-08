import Vapor

struct InfectionController: RouteCollection {
    func boot(router: Router) throws {
        let infectionRouter = router.grouped("infections")
        
        infectionRouter.get("", use: getInfectionsOfCountry)
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
}
