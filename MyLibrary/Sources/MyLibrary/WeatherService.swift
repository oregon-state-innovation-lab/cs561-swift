import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let url = "http://localhost:3000/v1/weather"
    private let authService: AuthService = AuthServiceImpl()

    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        authService.getToken { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(.failure(error))
            case let .success(token):
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + token
                ]
                AF.request(self.url, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                    switch response.result {
                    case let .success(weatherResponse):
                        let msg = weatherResponse
                        print("Success Response", msg)
                        completion(.success(Int(msg.main.temp)))
                    case let .failure(error):
                        print( "Error Response", error)
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

// MARK: - Weather
public struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
