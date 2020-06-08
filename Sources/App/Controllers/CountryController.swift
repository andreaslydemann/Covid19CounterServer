import Vapor

struct CountryController: RouteCollection {
    func boot(router: Router) throws {
        let countriesRouter = router.grouped("countries")
    
        countriesRouter.post(CreateCountryRequest.self, at: "", use: createCountry)
        countriesRouter.get("", use: getCountries)
    }
}

private extension CountryController {
    func getCountries(_ req: Request) throws -> Future<[CountryResponse]> {
        let repository = try req.make(CountryRepository.self)
        return repository.findAll(on: req).map { countries in
            return countries.compactMap { CountryResponse(country: $0) }
        }
    }
    
    func createCountry(_ req: Request, createRequest: CreateCountryRequest) throws -> Future<HTTPStatus> {
        let country = Country(id: createRequest.countryCode, name: createRequest.name)
        let repository = try req.make(CountryRepository.self)
        return repository.save(country: country, on: req).transform(to: .created)
    }
    
    func deleteCountry(_ req: Request, deleteRequest: DeleteCountryRequest) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Country.self).flatMap { country in
            return country.delete(on: req)
        }.transform(to: .ok)
    }
}
