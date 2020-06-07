import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let countryController = CountryController()
    router.get("countries", use: countryController.index)
    router.post("countries", use: countryController.create)
    router.delete("countries", Country.parameter, use: countryController.delete)
    
    let infectionController = InfectionController()
    router.get("infections", Int.parameter, use: infectionController.index)
    //router.post("countries", use: countryController.create)
    //router.delete("countries", Country.parameter, use: countryController.delete)
}
