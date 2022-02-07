import Alamofire

public protocol WeatherService {
    func gettoken(completion: @escaping (_ response: String) -> Void)
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getGreeting(completion: @escaping (_ response: Result<String /* Greetings */, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let urlGreeting = "http://localhost:3000/v1/hello"
    let urlWeather  = "http://localhost:3000/v1/weather"
    let urlToken    = "http://localhost:3000/v1/auth"
    
    
    func gettoken(completion: @escaping (_ response: String) -> Void)
    {
        let parameters: Parameters = [
            "username": "kedar",
            "password": "password1"
        ]
        
        AF.request(urlToken, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: AuthToken.self)
        {
            response in
            switch response.result
            {
                case let .success(AuthToken):
                let token = AuthToken.token
                print(token)
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
private struct AuthToken: Decodable {
            let token: String
    }
    
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        let headers : HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"]

        AF.request(urlWeather, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Weather.self)
        {
            response in
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
    
    func getGreeting(completion: @escaping (Result<String, Error>) -> Void) {
        let headers : HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"]
        
        AF.request(urlGreeting, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Hello.self)
        {
            response in
            switch response.result {
            case let .success(hello):
                let message = hello.greeting
                completion(.success(message))

            case let .failure(error):
                completion(.failure(error))
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

private struct Hello: Decodable {
        let greeting: String
}

