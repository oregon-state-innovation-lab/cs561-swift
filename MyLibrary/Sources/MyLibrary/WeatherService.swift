import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getGreeting(completion: @escaping (_ response: Result<String /* Greeting */, Error>) -> Void)
}

public class WeatherServiceImpl: WeatherService {
    let auth_url = "http://localhost:3000/v1/auth/"
    let url      = "http://localhost:3000/v1/weather/"
    let hello_url = "http://localhost:3000/v1/hello/"
    //let url = "https://cs561-assignment3-pacey.s3.us-west-1.amazonaws.com/index.html"

    public init(){}

    public func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        // first do auth
        AF.request(auth_url, method: .post).validate(statusCode: 200..<300).responseDecodable(of: Token.self) { response in
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

        AF.request(auth_url, method: .post).validate(statusCode: 200..<300).responseDecodable(of: Token.self) { response in
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
