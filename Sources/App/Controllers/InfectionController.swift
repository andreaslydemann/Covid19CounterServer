import Vapor
import FluentSQLite

struct InfectionController {
    func index(_ req: Request) throws -> Future<Infection> {
        let countryCode = try req.parameters.next(Int.self)
        
        return Infection.query(on: req).filter(\.countryCode == countryCode).first().map(to: Infection.self) { infection in
            guard let infection = infection else {
                throw Abort(.notFound)
            }
            
            return infection
        }
    }
}
