import Alamofire

public protocol AuthService {
    func getAccessToken(completion: @escaping (_ response: Result<String /* AccessToken */, Error>) -> Void)
}

class AuthServiceImpl: AuthService {
    let url = "http://localhost:3000/v1/auth"

    func getAccessToken(completion: @escaping (_ response: Result<String /* AccessToken */, Error>) -> Void) {
        AF.request(url, method: .post, parameters: ["username": "choyongs", "password": "123456789"]).validate(statusCode: 200..<300).responseDecodable(of: Token.self) { response in
            switch response.result {
            case let .success(token):
                let jwt = token.AccessToken
                let exp = token.expires
                print("expire date : ", exp)
                print("jwt : ",jwt)
                print("-------------------------------")
                completion(.success(jwt))

            case let .failure(error):
                completion(.failure(error))
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
