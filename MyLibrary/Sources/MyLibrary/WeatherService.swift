import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}



//Add enum 
enum BaseUrl :String {
    case mock = "http://localhost:8080/weather"
    case prod = "https://api.openweathermap.org/data/2.5/weather"
}
class WeatherServiceImpl: WeatherService {
    let url: String
    init(prod: Bool? = false) {
        //need to fix mock
        if prod != true {
            self.url = "\(BaseUrl.mock.rawValue)?q=corvallis&appid=123"
        }
        else {
            self.url = "\(BaseUrl.prod.rawValue)?q=corvallis&units=imperial&appid=5449b409d9f28589554c5cbba4086849"
        }

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
