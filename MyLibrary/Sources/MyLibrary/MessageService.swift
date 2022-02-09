import Alamofire

public protocol HolaService {
    func getHola(completion: @escaping (_ response: Result<String /* Hola String */, Error>) -> Void)
}

class HolaServiceImpl: HolaService {
    private let AuthentService: AuthentService = AuthentServiceImpl()
    let url = "http://localhost:3000/v1/hello"
    
    
    func getHola(completion: @escaping (_ response: Result<String /* Hola */, Error>) -> Void) {
        AuthentService.getToken { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(.failure(error))
            case let .success(token):
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + token
                ]
                AF.request(self.url, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: Hola.self) { response in
                    switch response.result {
                    case let .success(Hola):
                        let msg = Hola.message
                        print("Recieved Holas: ", msg)
                        completion(.success(msg))
                    case let .failure(error):
                        print("HolaService Error: ", error)
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

private struct Hola: Decodable {
    let message: String
}
