import Alamofire

public protocol AuthentService {
    func getToken(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void)
}

class AuthentServiceImpl: AuthentService {
    let url = "http://localhost:3000/v1/auth"
    
    func getToken(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void) {
        AF.request(url, method: .post, parameters: ["username" : "test-user", "password" : "test-password"]).validate(statusCode: 200..<300).responseDecodable(of: Token.self) { response in
            switch response.result {
            case let .success(token):
                print("Recieved Access Token: ", token.accessToken)
                completion(.success(token.accessToken))
            case let .failure(error):
                print("AuthentService Error: ", error)
                completion(.failure(error))
            }
        }
    }
}

private struct Token: Decodable {
    let accessToken: String
    let expires: String
    
    enum CodingKeys : String, CodingKey {
        case accessToken = "access-token"
        case expires = "expires"
    }
    
}
