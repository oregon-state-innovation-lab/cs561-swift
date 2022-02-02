import Alamofire

public protocol HelloService {
    func getHelloResponse(completion: @escaping (_ response: Result<String /* Greeting String */, Error>) -> Void)
}

class HelloServiceImpl: HelloService {
    private let authService: AuthService = AuthServiceImpl()
    let url = "http://localhost:3000/v1/hello"
    
    
    func getHelloResponse(completion: @escaping (_ response: Result<String /* Greeting */, Error>) -> Void) {
        authService.getToken { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(.failure(error))
            case let .success(token):
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + token
                ]
                AF.request(self.url, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: hello.self) { response in
                    switch response.result {
                    case let .success(helloResponse):
                        let msg = helloResponse.response
                        print("Success Response", msg)
                        completion(.success(msg))
                    case let .failure(error):
                        print( "Error Response", error)
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

private struct hello: Decodable {
    let response: String
}
