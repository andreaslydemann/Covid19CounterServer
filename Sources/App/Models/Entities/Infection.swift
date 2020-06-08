import Vapor
import FluentSQLite

struct Infection {
    var id: Int?
    var count: Int
    var countryCode: Int
    
    init(id: Int? = nil, count: Int, countryCode: Int) {
        self.id = id
        self.count = count
        self.countryCode = countryCode
    }
}

extension Infection: SQLiteModel { }
extension Infection: Migration { }
extension Infection: Parameter { }
