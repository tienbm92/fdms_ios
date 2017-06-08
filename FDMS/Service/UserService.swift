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
    fileprivate var token: String = ""
    
    func getMessageError() -> String {
        if let error = self.errorInfo {
            return error.message
        } else {
            return ""
        }
    }
    
    func getToken() -> String {
        return self.token
    }
    
    func login(user: User, completion: @escaping (CompletionResult) -> Void) {
        if let inputApi = self.createParamLogin(user: user) {
            doExecuteChangeRequest(inputApi, completion: { (result, _) in
                if let result = result {
                    completion(.success(result))
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                }
            })
        } else {
            completion(.failure(APIServiceError.errorParseJSON))
        }
    }
    
    private func createParamLogin(user: User) -> APIInputBase? {
        var paramInfo = [String: String]()
        guard let password = user.password, let email = user.email else {
            return nil
        }
        paramInfo = ["user[email]": "\(email)", "user[password]": "\(password)"]
        if let param = addRequestParams(dict: paramInfo) {
            return APIInputBase(urlString: kSignInURL, param: param.origin(), requestType: .post)
        } else {
            return nil
        }
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
            let result = JsonParser.share.callToParser(option: .parserRawToUser, dataJson: response),
            let token = result.token,
            let data = result.dataObject else {
                return nil
        }
        self.token = token
        UserDefaults.standard.removeObject(forKey: kLoggedInUserKey)
        UserDefaults.standard.set(token, forKey: kLoggedInUserKey)
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
