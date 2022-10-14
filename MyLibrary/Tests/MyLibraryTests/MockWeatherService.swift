import Alamofire
import MyLibrary

class MockWeatherService: WeatherService {
    private var shouldSucceed: Bool
    private var shouldReturnTemperatureWithAnEight: Bool

    init(shouldSucceed: Bool, shouldReturnTemperatureWithAnEight: Bool) {
        self.shouldSucceed = shouldSucceed
        self.shouldReturnTemperatureWithAnEight = shouldReturnTemperatureWithAnEight
    }

    /// Returns current temperature in Farenheight
    func getTemperature() async throws -> Int {
        switch (shouldSucceed, shouldReturnTemperatureWithAnEight) {
        case (true, true):
            return 38

        case (true, false):
            return 39

        case (false, _):
            let error404 = AFError.explicitlyCancelled
            throw error404
        }
    }
}
