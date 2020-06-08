import Vapor

public func routes(_ router: Router, _ container: Container) throws {
    try router.register(collection: CountryController())
    router.get("status") { (req) -> HTTPStatus in
        return .ok
    }
}
