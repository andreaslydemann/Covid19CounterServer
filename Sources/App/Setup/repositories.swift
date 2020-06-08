import Vapor

public func setupRepositories(services: inout Services, config: inout Config) {
    services.register(SQLiteCountryRepository.self)
}
