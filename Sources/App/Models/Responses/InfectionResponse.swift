import Vapor

struct InfectionResponse: Content {
    let id: Int
    let count: Int
    let countryCode: Int
    
    init?(infection: Infection, countryCode: Int) {
        guard let infectionId = infection.id else { return nil }
        self.id = infectionId
        self.count = infection.count
        self.countryCode = infection.countryCode
    }
}
