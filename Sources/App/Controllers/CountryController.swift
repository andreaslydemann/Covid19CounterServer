import Vapor

struct CountryController: RouteCollection {
    func boot(router: Router) throws {
        let countriesRouter = router.grouped("countries")
        
        countriesRouter.get("", use: getCountries)
        countriesRouter.post(CreateCountryRequest.self, at: "", use: createCountry)
        countriesRouter.post(DeleteCountryRequest.self, at: "", use: deleteCountry)
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
        let countryRepository = try req.make(CountryRepository.self)
        let infectionRepository = try req.make(InfectionRepository.self)
        
        return countryRepository.save(country: country, on: req).map { newCountry -> Future<Infection> in
            guard let countryCode = newCountry.id else {
                throw Abort(.notFound)
            }
            
            return infectionRepository.save(infection: Infection(count: 0, countryCode: countryCode), on: req)
        }.transform(to: .created)
    }
    
    func deleteCountry(_ req: Request, deleteRequest: DeleteCountryRequest) throws -> Future<HTTPStatus> {
        let countryRepository = try req.make(CountryRepository.self)
        let infectionRepository = try req.make(InfectionRepository.self)
        
        return countryRepository.find(by: deleteRequest.countryCode, on: req).map { (country: Country) -> Future<Void> in
            return countryRepository.delete(country: country, on: req).map { _ in
                _ = infectionRepository.find(by: deleteRequest.countryCode, on: req).map { infection in
                    infectionRepository.delete(infection: infection, on: req)
                }
            }
        }.transform(to: .ok)
    }
}
