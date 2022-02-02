import Alamofire

public protocol AuthService {
    func getToken(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void)
}

class AuthServiceImpl: AuthService {
    let url = "http://localhost:3000/v1/auth"
    
    func getToken(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void) {
        AF.request(url, method: .post, parameters: ["username" : "user", "password" : "password"]).validate(statusCode: 200..<300).responseDecodable(of: AccessToken.self) { response in
            switch response.result {
            case let .success(token):
                print("Access Token: ", token.access_token)
                print("Expiry time", token.expires)
                completion(.success(token.access_token))
            case let .failure(error):
                print("Error Response ", error)
                completion(.failure(error))
            }
        }
    }
}

private struct AccessToken: Decodable {
    let access_token: String
    let expires: String
    
    enum CodingKeys : String, CodingKey {
        case access_token = "access_token"
        case expires = "expires"
    }
    
}
