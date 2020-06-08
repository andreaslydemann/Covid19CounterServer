import Vapor

struct CountryController: RouteCollection {
    func boot(router: Router) throws {
        let countriesRouter = router.grouped("countries")
        
        countriesRouter.get("", use: getCountries)
        countriesRouter.post(CreateCountryRequest.self, at: "", use: createCountry)
        countriesRouter.delete("", Int.parameter, use: deleteCountry)
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
        let countryRepository = try req.make(CountryRepository.self)
        let infectionRepository = try req.make(InfectionRepository.self)

        let country = Country(id: createRequest.countryCode, name: createRequest.name)
        let saveCountry = countryRepository.save(country: country, on: req)
        
        let infection = Infection(count: 0, countryCode: createRequest.countryCode)
        let saveInfection = infectionRepository.save(infection: infection, on: req)
        
        return saveCountry.and(saveInfection).transform(to: .created)
    }
    
    func deleteCountry(_ req: Request) throws -> Future<HTTPStatus> {
        let countryRepository = try req.make(CountryRepository.self)
        let infectionRepository = try req.make(InfectionRepository.self)
        let countryCode = try req.parameters.next(Int.self)
        
        let findCountry = countryRepository.find(by: countryCode, on: req)
        let findInfection = infectionRepository.find(by: countryCode, on: req)

        return findCountry.and(findInfection).map {(country, infection) -> Future<(Void, Void)> in
            let deleteCountry = countryRepository.delete(country: country, on: req)
            let deleteInfection = infectionRepository.delete(infection: infection, on: req)
            
            return deleteCountry.and(deleteInfection)
        }.transform(to: .ok)
    }
}
