import Vapor
import FluentSQLite

protocol CountryRepository: ServiceType {
    func findAll(on connectable: DatabaseConnectable) -> Future<[Country]>
    func save(country: Country, on connectable: DatabaseConnectable) -> Future<Country>
    func delete(country: Country, on connectable: DatabaseConnectable) -> Future<Void>
}

final class SQLiteCountryRepository: CountryRepository {
    func findAll(on connectable: DatabaseConnectable) -> Future<[Country]> {
        return Country.query(on: connectable).all()
    }
    
    func save(country: Country, on connectable: DatabaseConnectable) -> Future<Country> {
        return country.save(on: connectable)
    }
    
    func delete(country: Country, on connectable: DatabaseConnectable) -> Future<Void> {
        return country.delete(on: connectable)
    }
}

// MARK: - ServiceType conformance
extension SQLiteCountryRepository {
    static let serviceSupports: [Any.Type] = [CountryRepository.self]
    
    static func makeService(for worker: Container) throws -> Self {
        return .init()
    }
}
