import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

public enum BaseUrl : String {
    case productionUrl = "https://api.openweathermap.org/data/2.5/weather"
    case testUrl = "http://localhost:3002"
}
public class WeatherServiceImpl: WeatherService {
    let relativeUrl = "?q=corvallis&units=imperial&appid=<INSERT YOUR API KEY HERE>"
    let url = "\(BaseUrl.testUrl)/api/data/2.5/weather"

    public init() {}
    
    public func getTemperature() async throws -> Int {
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
