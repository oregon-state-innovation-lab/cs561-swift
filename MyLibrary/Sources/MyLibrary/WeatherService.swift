import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}
struct BaseUrls {
    static var actual = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=a9bb8f2519051a682442261045f4293f"
    static var local = "http://127.0.0.1:5000/data/2.5/weather"
}

class WeatherServiceImpl: WeatherService {
    
//        let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=a9bb8f2519051a682442261045f4293f"
    let url = BaseUrls.actual
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
