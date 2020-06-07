import Vapor

struct CountryController {
    func index(_ req: Request) throws -> Future<[Country]> {
        return Country.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<Country> {
        return try req.content.decode(Country.self).flatMap { country in
            return country.create(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Country.self).flatMap { country in
            return country.delete(on: req)
        }.transform(to: .ok)
    }
}
