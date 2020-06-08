import Vapor

struct CreateCountryRequest: Content {
    var countryCode: Int
    var name: String
}
