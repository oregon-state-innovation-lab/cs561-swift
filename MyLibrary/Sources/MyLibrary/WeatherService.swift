import Alamofire
import Darwin

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getGreeting(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void)

    
}

class WeatherServiceImpl: WeatherService {
   
    
    //let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=<INSERT YOUR API KEY HERE>"
      let url = "http://54.234.254.71:3000/v1/weather"
      //let url2 = "http://localhost:3000/v1/hello"
    let parameters = ["username":"Amulya", "password": "123"]
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
    
    func getGreeting(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void) {
            
            AF.request("http://54.234.254.71:3000/v1/auth", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: Auth.self) { response in
                switch response.result {
                case let .success(auth):
                    print(auth)
                    let token = auth.access_token
                    let headers: HTTPHeaders = [
                        "Authorization": "Basic " + token,
                        "Accept": "application/json"
                    ]
                    AF.request("http://54.234.254.71:3000/v1/hello", method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: Greeting.self) { response in
                        switch response.result {
                        case let .success(greeting):
                            let message = greeting.message
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
    let message: String
}
