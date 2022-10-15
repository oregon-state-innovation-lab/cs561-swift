import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

enum Endpoints: String {
    case openWeathermap = "https://api.openweathermap.org"
    case mockService = "https://raw.githubusercontent.com/Hash7ag/mock-openweathermap-api/main"
}

class WeatherServiceImpl: WeatherService {
    private let api = "/data/2.5/weather?q=corvallis&units=imperial&appid=my-api-key"
    private var url: String

    init (ServiceCallSuccess:Bool? = true) {
        if ServiceCallSuccess == true {
            self.url = "\(Endpoints.mockService.rawValue)\(self.api)"
        }
        else {
            self.url = "\(Endpoints.mockService.rawValue)/fail\(self.api)"
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

struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
