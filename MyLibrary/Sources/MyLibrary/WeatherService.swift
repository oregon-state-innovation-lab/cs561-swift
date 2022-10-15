import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

enum BaseUrl : String {

            case realserver = "https://api.openweathermap.org"

            case localserver = "host.docker.internal:3000"
}

class WeatherServiceImpl: WeatherService {
    let url = "\(BaseUrl.realserver.rawValue)/data/2.5/weather?q=corvallis&units=imperial&appid=1b6fe56b923f4feee726f503f1d1c876"
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
