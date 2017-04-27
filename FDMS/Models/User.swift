//
//  User.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/18/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

enum ViewTag: Int {
    case emailTextField = 1
    case passwordTextField = 2
    case fullNameTextField = 3
    case retypePasswordTextField = 4
}

class User: Mappable {
    var uid: Int?
    var firstName: String = ""
    var lastName: String = ""
    var name: String {
        return firstName + lastName
    }
    var email: String?
    var address: String = ""
    var password: String?
    var resetDigest: String?
    var createdBy: Int?
    var updatedBy: Int?
    var createdAt: String = ""
    var updatedAt: String = ""
    var rememberDigest: String = ""
    var avatar: String?
    var fromExcel: Bool = false
    var gender: String = ""
    var role: String = ""
    var birthday: String = ""
    var employeeCode: String?
    var status: String = ""
    var contractDate: String?
    var startProbationDate: String?
    var endProbationDate: String?
    var rememberMe: Bool = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        uid <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        address <- map["address"]
        password <- map["password_digest"]
        resetDigest <- map["reset_digest"]
        createdBy <- map["created_by"]
        updatedBy <- map["updated_by"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        rememberDigest <- map["remember_digest"]
        avatar <- map["avatar"]
        fromExcel <- map["from_excel"]
        gender <- map["gender"]
        role <- map["role"]
        birthday <- map["birthday"]
        employeeCode <- map["employee_code"]
        status <- map["status"]
        contractDate <- map["contract_date"]
        startProbationDate <- map["start_probation_date"]
        endProbationDate <- map["end_probation_date"] 
    }
    
    init?(email: String?, password: String?, error: @escaping (String, Int) -> Void) {
        let validatedEmail = DataValidator.validate(string: email, fieldName: "Email",
                                                    minimumLength: nil, format: kEmailRegex, compareWith: nil)
        if !validatedEmail.isValid { error(validatedEmail.result, ViewTag.emailTextField.rawValue)
            return nil
        }
        let validatedPassword = DataValidator.validate(string: password, fieldName: "Password".localized,
                                                       minimumLength: kMinimumPasswordLength,
                                                       format: nil, compareWith: nil)
        if !validatedPassword.isValid {
            error(validatedPassword.result, ViewTag.passwordTextField.rawValue)
            return nil
        }
        self.email = validatedEmail.result
        self.password = validatedPassword.result
    }
    
}
