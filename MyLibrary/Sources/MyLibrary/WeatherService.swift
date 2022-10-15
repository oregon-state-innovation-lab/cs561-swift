import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

class WeatherServiceImpl: WeatherService {
    let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=3591f50bcb5933a821d5aad5d9c130bb"

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

private struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
