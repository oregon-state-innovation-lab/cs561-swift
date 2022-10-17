import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

class WeatherServiceImpl: WeatherService {
    let url = "https://api.openweathermap.org/data/2.5/weather?lat=27.6648&lon=-81.5158&appid=ff2529c7236c38a47c8a6bc178296eb9"

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

public struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
