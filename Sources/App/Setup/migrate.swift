import Vapor
import FluentSQLite

public func migrate(migrations: inout MigrationConfig) throws {
    migrations.add(model: Country.self, database: DatabaseIdentifier<Country.Database>.sqlite)
    migrations.add(model: Infection.self, database: DatabaseIdentifier<Infection.Database>.sqlite)
}
