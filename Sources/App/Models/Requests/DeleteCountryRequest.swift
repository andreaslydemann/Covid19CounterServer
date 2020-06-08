import Vapor

struct DeleteCountryRequest: Content {
    var countryCode: Int
}
