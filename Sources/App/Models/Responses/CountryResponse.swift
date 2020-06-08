import Vapor

struct CountryResponse: Content {
    
    let id: Int
    let name: String
    
    init?(country: Country) {
        guard let countryId = country.id else { return nil }
        self.id = countryId
        self.name = country.name
    }
}
