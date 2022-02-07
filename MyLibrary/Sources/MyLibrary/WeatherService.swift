import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getMessage(completion: @escaping (_ response: Result<String /* Welcome */, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let authUrl = "http://172.20.20.20:3000/v1/auth/"
    let tempUrl = "http://172.20.20.20:3000/v1/weather/"
    let helloUrl = "http://172.20.20.20:3000/v1/hello/"
    let parameters = ["username": "cs561-se", "password": "LetMeIn"]

    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        AF.request(self.authUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:nil).responseDecodable(of: Token.self) { response in
            switch response.result {
            case let .success(auth):
                let token = auth.jwt
                let header: HTTPHeaders = ["Authorization":  "Bearer \(token)"]

                AF.request(self.tempUrl, method: .get, headers: header).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                    switch response.result {
                    case let .success(weather):
                        let temperature = weather.main.temp
                        print("Temperature in Corvallis: ",temperature)
                        let temperatureAsInteger = Int(temperature)
                        completion(.success(temperatureAsInteger))

                    case let .failure(error):
                        print(error)
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    func getMessage(completion: @escaping (_ response: Result<String /* Welcome */, Error>) -> Void) {
        AF.request(self.authUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:nil).responseDecodable(of: Token.self) { response in
            switch response.result {
            case let .success(auth):
                let token = auth.jwt
                let header: HTTPHeaders = ["Authorization":  "Bearer \(token)"]

                AF.request(self.helloUrl, method: .get, headers: header).validate(statusCode: 200..<300).responseDecodable(of: String.self) { response in
                    switch response.result {
                    case let .success(welcome):
                        print("Welcome Msg: ",welcome)
                        completion(.success(welcome))

                    case let .failure(error):
                        print(error)
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

private struct Token: Decodable {
    let jwt,exp : String
}