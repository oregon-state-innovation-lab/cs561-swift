import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}
enum BaseUrl : String {
      case openweathermap = "https://api.openweathermap.org"
      case mockServer = "http://localhost:3000/data/2.5/weather"
}

class WeatherServiceImpl: WeatherService {
    //let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=<INSERT YOUR API KEY HERE>"
    let url = "https://api.openweathermap.org/data/2.5/weather?lat=44.5645659&lon=-123.2620435&appid=5bf2d50037bf3fa921c47c747ef59bce"

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
