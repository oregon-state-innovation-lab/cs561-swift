import Alamofire
public protocol WeatherService {
    func getTemperature() async throws -> Int
}
enum BaseUrl: String {
    case openweathermap = "https://api.openweathermap.org"
    case mockServer = "http://localhost:3000"

}
class WeatherServiceImpl: WeatherService {
    //let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=0d4c3c05756767f0202df9dd82e9d402"

    var url = "/data/2.5/weather"
    public init(baseUrl: BaseUrl = BaseUrl.mockServer){
        self.url="\(baseUrl.rawValue)"+url
        print(self.url)
    }
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
