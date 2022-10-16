import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

enum BaseURL: String{
    case openWeatherMap = "https://api.openweathermap.org"
    case mockServer = "http://host.docker.internal:3000"
}


class WeatherServiceImpl: WeatherService {
    let url = "\(BaseURL.mockServer.rawValue)/data/2.5/weather?lat=44.5646&lon=123.2620&appid=1f9d4aeb62f58286235d57f5a02a7808"

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
