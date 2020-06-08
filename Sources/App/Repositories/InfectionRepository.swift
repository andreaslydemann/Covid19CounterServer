import Vapor
import FluentSQLite

protocol InfectionRepository: ServiceType {
    func find(by countryCode: Int, on connectable: DatabaseConnectable) -> Future<Infection>
}

final class SQLiteInfectionRepository: InfectionRepository {
    func find(by countryCode: Int, on connectable: DatabaseConnectable) -> Future<Infection> {
        return Infection.query(on: connectable)
            .filter(\.countryCode == countryCode)
            .first()
            .map(to: Infection.self) { infection in
                guard let infection = infection else {
                    throw Abort(.notFound)
                }
                
                return infection
        }
    }
}

// MARK: - ServiceType conformance
extension SQLiteInfectionRepository {
    static let serviceSupports: [Any.Type] = [InfectionRepository.self]
    
    static func makeService(for worker: Container) throws -> Self {
        return .init()
    }
}
