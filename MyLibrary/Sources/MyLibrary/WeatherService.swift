import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
}

public class WeatherServiceImpl: WeatherService {
    //let url = "https://localhost:7878/data/2.5/weather/"
    //let url = "http://10.6.1.149:7878/data/2.5/weather/"
    //let url = "https://api.openweathermap.org/data/2.5/weather?q=Corvallis,US&appid=ab6cdb14a4408ca29f5d2ae96e32058c&units=imperial"
    let url = "http://localhost:3000/data/2.5/weather/"
    //let url = "https://cs561-assignment3-pacey.s3.us-west-1.amazonaws.com/index.html"
    //let url = "http://172.20.0.2:3000/data/2.5/weather/"

    public init(){
    }

    public func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
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
        }
    }
}

private struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
