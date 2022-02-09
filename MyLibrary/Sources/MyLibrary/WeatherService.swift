import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    private let AuthentService: AuthentService = AuthentServiceImpl()
    
    let url = "http://localhost:3000/v1/weather"
    
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        
        AuthentService.getToken { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(.failure(error))
            case let .success(token):
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + token
                ]
                AF.request(self.url, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                    switch response.result {
                    case let .success(weather):
                        let temperature = weather.main.temp
                        let temperatureAsInteger = Int(temperature)
                        print("Recieved Temperature: ", temperatureAsInteger)
                        completion(.success(temperatureAsInteger))
                    case let .failure(error):
                        print("WeatherService Error: ", error)
                        completion(.failure(error))
                    }
                }
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
