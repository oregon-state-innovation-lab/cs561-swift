import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

enum BaseUrl :String {
    case realapi = "https://api.openweathermap.org/data/2.5/weather"
    case mockserver = "http://localhost:3000/data/2.5/weather"
}

class WeatherServiceImpl: WeatherService {
    let url = "https://api.openweathermap.org/data/2.5/weather?lat=44.5646&lon=-123.2620&appid=0ca5e721078f1ed3c0a771d6f9c54274"

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
