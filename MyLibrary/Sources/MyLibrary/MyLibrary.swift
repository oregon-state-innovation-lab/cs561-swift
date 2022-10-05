public class MyLibrary {
    private let weatherService: WeatherService

    /// The class's initializer.
    ///
    /// Whenever we call the `MyLibrary()` constructor to instantiate a `MyLibrary` instance,
    /// the runtime then calls this initializer.  The constructor returns after the initializer returns.
    public init(weatherService: WeatherService? = nil) {
        self.weatherService = weatherService ?? WeatherServiceImpl()
    }

    public func isLucky(_ number: Int) async -> Bool? {
        // Check the simple case first: 3, 5 and 8 are automatically lucky.
        if number == 3 || number == 5 || number == 8 {
            return true
        }

        // Fetch the current weather from the backend.
        // If the current temperature, in Farenheit, contains an 8, then that's lucky.
        do {
            let temperature = try await weatherService.getTemperature()
            return temperature.contains("8")
        } catch {
            return nil
        }
    }
}

private extension Int {
    /// Sample usage:
    ///   `558.contains(558, "8")` would return `true` because 588 contains 8.
    ///   `557.contains(557, "8")` would return `false` because 577 does not contain 8.
    func contains(_ character: Character) -> Bool {
        return String(self).contains(character)
    }
}
