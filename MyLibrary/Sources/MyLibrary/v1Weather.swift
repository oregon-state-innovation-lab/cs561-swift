import Alamofire

public protocol v1Weather {
    func getWeather(completion: @escaping (_ response: Result<String /* weatherData */, Error>) -> Void)
}

class v1WeatherImpl: v1Weather {
    let url = "http://localhost:3000/v1/weather"
    private let authService: AuthService = AuthServiceImpl()
    
    func getWeather(completion: @escaping (_ response: Result<String /* weatherData */, Error>) -> Void) {
        
        authService.getAccessToken { response in
            switch response {
            case let .success(token):
                let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
                AF.request(self.url, method: .get, headers: headers).validate(statusCode: 200..<300).responseString {
                    response in switch response.result {
                    case let .success(Weather):
                        let data = Weather
                        print("weather data : ",data)
                        completion(.success(data))
                    case let .failure(Error):
                        print(Error)
                        completion(.failure(Error))
                    }
                    
                }
                
            case let .failure(Error):
                print(Error)
            }
        }

    }
}

private struct Token: Decodable {
    let AccessToken: String
    let expires: String
    
    enum CodingKeys : String, CodingKey {
        case AccessToken = "AccessToken"
        case expires = "Expires"
    }
}

private struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
