import Alamofire
import Combine

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getGreeting(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let url = "http://44.202.135.66/:3000/v1/weather"
    let parameters = ["username": "Abhi", "password": "password"]
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        
        AF.request("http://44.202.135.66/:3000/v1/auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: Auth.self) { response in
            switch response.result {
            case let .success(auth):
                let token = auth.access_token
                print(token)
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + token,
                    "Accept": "application/json"
                ]
                AF.request("http://44.202.135.66/:3000/v1/weather", method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                    switch response.result {
                    case let .success(weather):
                        let temperature = weather.main.temp
                        let temperatureAsInteger = Int(temperature)
                        completion(.success(temperatureAsInteger))

                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
            }
    func getGreeting(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void) {
        
        AF.request("http://44.202.135.66/:3000/v1/auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: Auth.self) { response in
            switch response.result {
            case let .success(auth):
                print(auth)
                let token = auth.access_token
                print("token = "+token)
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + token,
                    "Accept": "application/json"
                ]
                print("headers = ")
                print(headers)
                AF.request("http://44.202.135.66/:3000/v1/hello", method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: Greeting.self) { response in
                    switch response.result {
                    case let .success(msg):
                        print("greeting = ")
                        print(msg)
                        let message = msg.greeting
                        print(message)
                        completion(.success(message))

                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
            }
}

private struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}

private struct Auth: Decodable {
    let access_token, expires: String
}

private struct Greeting: Decodable {
    let greeting: String
}
