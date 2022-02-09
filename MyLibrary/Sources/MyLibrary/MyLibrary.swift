public class MyLibrary {
    private let weatherService: WeatherService
    private let HolaSerive: HolaService = HolaServiceImpl()
    /// The class's initializer.
    ///
    /// Whenever we call the `MyLibrary()` constructor to instantiate a `MyLibrary` instance,
    /// the runtime then calls this initializer.  The constructor returns after the initializer returns.
    public init(weatherService: WeatherService? = nil) {
        self.weatherService = weatherService ?? WeatherServiceImpl()
    }
    
    public func getTemperature(completion: @escaping (Int?) -> Void){
        weatherService.getTemperature { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(nil)
                
            case let .success(temperature):
                completion(temperature)
            }
        }
    }
    
    public func getHola(completion: @escaping (String?) -> Void){
        HolaSerive.getHola { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(nil)
                
            case let .success(Hola):
                completion(Hola)
            }
        }
    }
    
    public func isLucky(_ number: Int, completion: @escaping (Bool?) -> Void) {
        // Check the simple case first: 3, 5 and 8 are automatically lucky.
        if number == 3 || number == 5 || number == 8 {
            completion(true)
            return
        }
        
        // Fetch the current weather from the backend.
        // If the current temperature, in Farenheit, contains an 8, then that's lucky.
        weatherService.getTemperature { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(nil)
                
            case let .success(temperature):
                if self.contains(temperature, "8") {
                    completion(true)
                } else {
                    let isLuckyNumber = self.contains(temperature, "8")
                    completion(isLuckyNumber)
                }
            }
        }
    }
    
    /// Sample usage:
    ///   `contains(558, "8")` would return `true` because 588 contains 8.
    ///   `contains(557, "8")` would return `false` because 577 does not contain 8.
    private func contains(_ lhs: Int, _ rhs: Character) -> Bool {
        return String(lhs).contains(rhs)
    }
}
