import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}
enum BaseUrl : String {
     case openWeather = "http://api.openweathermap.org"
     case mockServer = "http://localhost:3000/data/2.5/weather"

}
class WeatherServiceImpl: WeatherService {
    let url = "https://20360a30-59c2-4760-a55a-128fbe6fb320.mock.pstmn.io/data/2.5/weather"

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
