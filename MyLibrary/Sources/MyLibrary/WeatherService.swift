import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getGreeting(completion: @escaping (_ response: Result<String /* Greeting */, Error>) -> Void)
}

public class WeatherServiceImpl: WeatherService {
    // aws elastic ip: 55.55.131.241
    let auth_url = "http://52.55.131.241:3000/v1/auth/"
    let url      = "http://52.55.131.241:3000/v1/weather/"
    let hello_url = "http://52.55.131.241:3000/v1/hello/"

    // user params for auth login
    let user_param = ["username": "joe", "password": "my_password2"]

    public init(){}

    public func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        // first do auth
        let user_param = ["username": "joe", "password": "my_password2"]

        AF.request(auth_url, method: .post, parameters: user_param).validate(statusCode: 200..<300).responseDecodable(of: Token.self) { response in
        switch response.result {
            case let .success(token):
                // parse access token from auth
                let access_token = token.main.token

                // add token to request for weather
                let param = ["token": access_token]
                AF.request(self.url, method: .get, parameters: param).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response2 in
                    switch response2.result {
                    case let .success(weather):
                        let temperature = weather.main.temp
                        let temperatureAsInteger = Int(temperature)
                        completion(.success(temperatureAsInteger))

                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    public func getGreeting(completion: @escaping (_ response: Result<String /* Message */, Error>) -> Void) {
        AF.request(auth_url, method: .post, parameters: user_param).validate(statusCode: 200..<300).responseDecodable(of: Token.self) { response in
            switch response.result {
            case let .success(token):
                // get access token from auth
                let access_token = token.main.token

                let param = ["token": access_token]

                AF.request(self.hello_url, method: .get, parameters: param).validate(statusCode: 200..<300).responseDecodable(of: Hello.self) { response2 in
                    print("RESPONSE 2")
                    print(response2)
                    switch response2.result {
                    case let .success(hello):
                        let greeting = hello.main.greeting
                        completion(.success(greeting))

                    case let .failure(error):
                        completion(.failure(error))
                    }
                }

            case let .failure(error):
                print("AUTH FAILURE")
                print(error)
                completion(.failure(error))
            }
        }
    }
}

private struct Token: Decodable {
    let main: Main

    struct Main: Decodable {
        let token: String
    }
}

private struct Hello: Decodable {
    let main: Main

    struct Main: Decodable {
        let greeting: String
    }
}

private struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
