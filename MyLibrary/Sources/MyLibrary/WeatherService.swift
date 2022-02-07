import Alamofire
import Foundation

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getAuthorization(completion: @escaping (_ accessToken: String) -> Void)
    func getGreeting(completion: @escaping (_ response: Result<String, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=<INSERT YOUR API KEY HERE>"

    let urlAuth = "http://localhost:3000/v1/auth"
    let urlWeather = "http://localhost:3000/v1/weather"
    let urlHello = "http://localhost:3000/v1/hello"

    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case let .success(weather):
                let temperature = weather.main.temp
                let temperatureAsInteger = Int(temperature)
                completion(.success(temperatureAsInteger))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    func getAuthorization(completion: @escaping (_ accessToken: String) -> Void) -> Void {
        let params: Parameters = [
            "username": "karl",
            "password": "adriano"
        ]

        AF.request(urlAuth, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
           .validate(statusCode: 200..<300)
           .responseDecodable(of: Token.self) {
                AFdata in
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    let token = jsonObject["accesstoken"] as! String
                    completion(token)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    completion("")
                }
            }
    }
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        self.getAuthorization(completion: { accessToken in
            let headers : HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
            AF.request(self.urlWeather, method: .get, headers: headers)
                .debugLog()
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Weather.self) { response in
                    switch response.result {
                    case let .success(weather):
                        let temperature = weather.main.temp
                        print(temperature)
                        let temperatureAsInteger = Int(temperature)
                        completion(.success(temperatureAsInteger))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
        })
    }

    func getGreeting(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void) {
        self.getAuthorization(completion: { accessToken in
            let headers : HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
            AF.request(self.urlHello, method: .get, headers: headers)
                .debugLog()
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Greeting.self) { response in
                    switch response.result {
                    case let .success(hello):
                        let message = hello.greeting 
                        print(message)
                        completion(.success(message))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }   
        })       
    }
}
private struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}

private struct Token: Decodable {
    let accesstoken: String
}

private struct Greeting: Decodable {
    let greeting: String
}