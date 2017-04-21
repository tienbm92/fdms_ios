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

class UserService {
    
    static let share: UserService = UserService()
    
    func login(user: User, completion: @escaping (UserResult) -> Void) {
        guard let password = user.password,
            let email = user.email else {
            completion(.failure(APIServiceError.errorSystem))
            return
        }
        let infoDict = ["user[email]": "\(email)", "user[password]": "\(password)"]
        Alamofire.request(kSignInURL, method: .post, parameters: infoDict,
                          headers: headers).responseData { (response) in
            guard let jsonInput = response.result.value else {
                completion(.failure(APIServiceError.errorSystem))
                return
            }
            let (status, data, token) = JsonParser.share.parserRawToUser(JsonInput: jsonInput)
            if status == APIServiceError.errorParseJSON {
                completion(.failure(APIServiceError.errorParseJSON))
                return
            }
            if status == APIServiceError.errorNotFound {
                completion(.failure(APIServiceError.errorParseJSON))
                return
            }
            guard let resultData = data,
                let resultToken = token else {
                completion(.failure(APIServiceError.errorSystem))
                return
            }
            DataStore.shared.currentToken = resultToken
            let dataUser = User(JSON: resultData)
            if let dataUser = dataUser {
                completion(.success(dataUser))
            } else {
                completion(.failure(APIServiceError.errorLogin))
            }
        }
    }
    
}
