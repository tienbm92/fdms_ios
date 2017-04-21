//
//  UserService.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/26/17.
//  Copyright © 2017 Framgia. All rights reserved.
//
import Alamofire
import Foundation

enum UserResult {
    case success(User)
    case failure(Error)
}

enum UserServiceError: Int {
    case notFound = 500
}

class UserService: APIService {
    
    static let share: UserService = UserService()
    fileprivate var errorInfo: ErrorInfo?
    
    func getMessageError() -> String {
        if let error = self.errorInfo {
            return error.message
        } else {
            return ""
        }
    }
    
    func login(user: User, completion: @escaping (CompletionResult) -> Void) {
        if let urlRequest = self.createParamLogin(user: user) {
            doExecuteGetRequest(urlReuqest: urlRequest, completion: { (result, error) in
                if let result = result, let _ = error {
                    completion(.success(result))
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                }
            })
        } else {
            completion(.failure(APIServiceError.errorParseJSON))
        }
    }
    
    private func createParamLogin(user: User) -> URLRequest? {
        var paramInfo = [String: String]()
        guard let password = user.password, let email = user.email else {
            return nil
        }
        paramInfo = ["user[email]": "\(email)", "user[password]": "\(password)"]
        if let param = addRequestParams(dict: paramInfo),
           let urlRequest = asChangeRequest(parameters: param.origin(), url: kSignInURL, method: .post) {
            return urlRequest
        }
        return nil
    }
    
    override func onFinish(_ response: Any?, statusCode: Int, error: ErrorInfo?,
                           completion: NetworkServiceCompletion?) {
        let dataResult: Any?
        if let result = response, let error = error {
            dataResult = self.parserLogin(data: result, error: error)
            self.errorInfo = error
            super.onFinish(dataResult, error: error, completion: completion)
        } else {
            super.onFinish(nil, error: nil, completion: completion)
        }
    }
    
    private func parserLogin(data: Any?, error: ErrorInfo?) -> User? {
        guard let response = data, let error = error,
            let result = JsonParser.share.parserRawToUser(JsonInput: response),
            let token = result.token,
            let data = result.dataObject else {
                return nil
        }
        DataStore.shared.currentToken = token
        switch error.status {
        case StatusCode.invalidError.rawValue:
            return nil
        case StatusCode.pleaseLogin.rawValue:
            return nil
        case StatusCode.noPermission.rawValue:
            return nil
        default:
            break
        }
        let dataUser = User(JSON: data)
        if let dataUser = dataUser {
            return dataUser
        } else {
            return nil
        }
    }
    
}
