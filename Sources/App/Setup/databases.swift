import Vapor
import FluentSQLite

public func databases(config: inout DatabasesConfig) throws {
    guard let databasePath: String = Environment.get("DATABASE_PATH") else {
        throw Abort(.internalServerError)
    }
    
    let db = try SQLiteDatabase(storage: .file(path: databasePath))
    config.add(database: db, as: .sqlite)
}
