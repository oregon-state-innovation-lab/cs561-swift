import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
}

public class WeatherServiceImpl: WeatherService {
    //let url = "https://localhost:7878/data/2.5/weather/"
    //let url = "http://10.6.1.149:7878/data/2.5/weather/"
    //let url = "https://api.openweathermap.org/data/2.5/weather?q=Corvallis,US&appid=ab6cdb14a4408ca29f5d2ae96e32058c&units=imperial"
    let auth_url = "http://localhost:3000/v1/auth/"
    let url      = "http://localhost:3000/v1/weather/"
    //let url = "https://cs561-assignment3-pacey.s3.us-west-1.amazonaws.com/index.html"
    //let url = "http://172.20.0.2:3000/data/2.5/weather/"

    let access_token = ""

    public init(){
       // let access_token = self.getAuth()
    }

    public func getAuth(completion: @escaping (_ response: Result<String /* token */, Error>) -> Void) {
        print("Running on url: " + auth_url)
        AF.request(auth_url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Token.self) { response in
            switch response.result {
            case let .success(token):
                let access_token = "Abc" //Token.main.access
                //let temperatureAsInteger = Int(temperature)
                //completion(.success(access_token))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    public func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        if (access_token == ""){
            print("DOING AUTH")

            AF.request(auth_url, method: .post).validate(statusCode: 200..<300).responseDecodable(of: Token.self) { response in
                switch response.result {
                case let .success(token):
                    print("THIS IS THE TOKEN")
                    //print(token)
                    let access_token = token.main.token
                    print(access_token)
                    //let temperatureAsInteger = Int(temperature)
                    //completion(.success(access_token))
                    print("Running on url: " + self.url)

                    let param = ["token": access_token]

                    AF.request(self.url, method: .get, parameters: param).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response2 in
                        print("RESPONSE 2")
                        print(response2)
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
                    print("AUTH FAILURE")
                    print(error)
                    completion(.failure(error))


                }
                print("BLAH")
            }
        }
        /*
        print("Running on url: " + url)
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case let .success(weather):
                let temperature = weather.main.temp
                let temperatureAsInteger = Int(temperature)
                completion(.success(temperatureAsInteger))

            case let .failure(error):
                completion(.failure(error))
            }
        }*/
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
