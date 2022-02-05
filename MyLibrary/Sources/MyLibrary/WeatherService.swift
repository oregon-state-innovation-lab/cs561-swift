import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getHello(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    

    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        var token : String?
        self.getToken { response in
            switch response {
            case let .failure(error):
                print(error)


            case let .success(token):
                let url = "http://34.201.45.238:3000/v1/weather?token="+token
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
        }
        

        
    }
    func getHello(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void) {
        
        var token : String?
        self.getToken { response in
            switch response {
            case let .failure(error):
                print(error)


            case let .success(token):
                let url = "http://34.201.45.238:3000/v1/hello?token="+token
                AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Hello.self) { response in
                    switch response.result {
                    case let .success(hello):
                        

                        completion(.success(hello.msg))

                    case let .failure(error):

                        completion(.failure(error))
                    }
                }
            }
        }
        

        
    }
    func getToken(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void) {
        var token : String?
        
        


        AF.request("http://34.201.45.238:3000/v1/auth", method: .post).validate(statusCode: 200..<300).responseDecodable(of: Token.self) { response in
            switch response.result {
            case let .success(token):
                
                completion(.success(token.token))

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

private struct Token: Decodable {
    let token: String

}

private struct Hello: Decodable {
    let msg: String

}


