public class MyLibrary {
    private let weatherService: WeatherService
    private let AuthService: AuthService = AuthServiceImpl()
    private let v1Weather: v1Weather = v1WeatherImpl()
    private let v1Hello: v1Hello = v1HelloImpl()
    /// The class's initializer.
    ///
    /// Whenever we call the `MyLibrary()` constructor to instantiate a `MyLibrary` instance,
    /// the runtime then calls this initializer.  The constructor returns after the initializer returns.
    public init(weatherService: WeatherService? = nil) {
        self.weatherService = weatherService ?? WeatherServiceImpl()
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
    /// 'conatains(555, "8")'
    private func contains(_ lhs: Int, _ rhs: Character) -> Bool {
        return String(lhs).contains(rhs)
    }
    
    public func getAuth(completion: @escaping (String?) -> Void){
        AuthService.getAccessToken { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(nil)

            case let .success(jwt):
                completion(jwt)
            }
        }
    }
    
    public func getWeather(completion: @escaping (String?) -> Void){
        v1Weather.getWeather { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(nil)

            case let .success(temp):
                completion(temp)
            }
        }
    }
    
    public func getHello(completion: @escaping (String?) -> Void){
        v1Hello.getHello { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(nil)

            case let .success(message):
                completion(message)
            }
        }
    }
    
}
