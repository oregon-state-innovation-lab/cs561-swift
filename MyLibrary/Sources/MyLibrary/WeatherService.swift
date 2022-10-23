import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

enum endpointURL : String {
    case realURL = "https://api.openweathermap.org"
    case mockURL = "http://localhost:3000/data/2.5/weather"
}

class WeatherServiceImpl: WeatherService {
//    let url = "\(endpointURL.realURL.rawValue)/data/2.5/weather?q=corvallis&units=imperial&appid=1616c389758df20554e3d45003e939d4"
    private var url: String
    init (ServiceCallSuccess:Bool? = true) {
        if ServiceCallSuccess == true {
            self.url = "\(endpointURL.realURL.rawValue)/data/2.5/weather?q=corvallis&units=imperial&appid=1616c389758df20554e3d45003e939d4"
        }
        else {
            self.url = "\(endpointURL.mockURL.rawValue)/fail/data/2.5/weather?q=corvallis&units=imperial&appid=1616c389758df20554e3d45003e939d4"
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
