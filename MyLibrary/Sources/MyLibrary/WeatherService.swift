import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

enum Endpoints: String {
    case openWeathermap = "https://api.openweathermap.org"
    case mockService = "https://raw.githubusercontent.com/Hash7ag/mock-openweathermap-api/main"
}

class WeatherServiceImpl: WeatherService {
    let url = "\(Endpoints.mockService.rawValue)/data/2.5/weather?q=corvallis&units=imperial&appid=my-api-key"

    func getTemperature() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                switch response.result {
                case let .success(weather):
                    let temperature = weather.main.temp
                    let temperatureAsInteger = Int(temperature)
                    continuation.resume(with: .success(temperatureAsInteger))

                case let .failure(error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}

struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
