import Alamofire

public protocol v1Hello {
    func getHello(completion: @escaping (_ response: Result<String /* hello msg */, Error>) -> Void)
}

class v1HelloImpl: v1Hello {
    let url = "http://localhost:3000/v1/hello"
    private let authService: AuthService = AuthServiceImpl()
    
    func getHello(completion: @escaping (_ response: Result<String /* hello msg */, Error>) -> Void) {
        
        authService.getAccessToken { response in
            switch response {
            case let .success(token):
                let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
                AF.request(self.url, method: .get, headers: headers).validate(statusCode: 200..<300).responseString {
                    response in switch response.result {
                    case let .success(helloRes):
                        let message = helloRes
                        print("--------------msg-----------------")
                        print("msg : ",message)
                        completion(.success(message))
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

private struct hello: Decodable {
    let res: String
}
