import Alamofire
import SwiftUI

public protocol WeatherService {
 //   func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    
    //fetch JWT
    func userLogin(completion: @escaping (_ response: Result<String /* JWT */, Error>) -> Void)
    
    //hello
    func getHello(token: String, completion: @escaping (_ response: Result<String /* greetings */, Error>) -> Void)
    
    //weather
    func getWeather(token: String, completion: @escaping (_ response: Result<String /* weather */, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=<INSERT YOUR API KEY HERE>"
    
    let weatherUrl = "http://localhost:3000/v1/weather"
    func getWeather(token: String, completion: @escaping (_ response: Result<String /* weather */, Error>) -> Void){
        let headerString = "Bearer " + token
        
        let myHeaders: HTTPHeaders = [
            "Authorization": headerString
        ]
        
        AF.request(weatherUrl, method: .get, headers: myHeaders).validate(statusCode: 200..<300).responseDecodable(of: WeatherForm.self){
            response in
            switch response.result {
            case.success(let value):
                let weather = value.base
                completion(.success(weather))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    let authUrl = "http://localhost:3000/v1/auth"
    func userLogin(completion: @escaping (_ response: Result<String /* JWT */, Error>) -> Void) {
        let login = Login(username: "John Doe", password: "abc123")
        AF.request(authUrl, method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseDecodable(of: JWT.self){
            response in
            switch response.result {
            case.success(let value):
                let userJWT = value.access_token
                completion(.success(userJWT))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    let helloUrl = "http://localhost:3000/v1/hello"
    func getHello(token: String, completion: @escaping (_ response: Result<String /* greetings */, Error>) -> Void){
        let headerString = "Bearer " + token
        
        let myHeaders: HTTPHeaders = [
            "Authorization": headerString
        ]
        
        AF.request(helloUrl, method: .get, headers: myHeaders).validate(statusCode: 200..<300).responseDecodable(of: Greeting.self){
            response in
            switch response.result {
            case.success(let value):
                let greetings = value.message
                completion(.success(greetings))
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


struct WeatherForm: Codable {
    let coord: Coord
    let weather: [Weather]
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

// MARK: - Weather
struct Weather: Codable {
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

private struct JWT: Decodable {
    let access_token: String
    let expires: String
    
    enum CodingKeys: String, CodingKey {
        case access_token = "access-token"
        case expires = "expires"
    }
}

struct Login: Decodable, Encodable {
    let username: String
    let password: String
}

private struct Greeting: Decodable {
    let message: String
}


