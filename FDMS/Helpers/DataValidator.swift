//
//  DataValidator.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/19/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class DataValidator {
    
    class func validate(string: String?, fieldName: String, minimumLength: Int?, format: String?,
                        compareWith: (compareString: String, compareFieldName: String)?) ->
            (isValid: Bool, result: String) {
        guard let string = string else {
            return (false, String(format: "not.empty".localized, fieldName))
        }
        if string.isEmpty {
            return (false, String(format: "not.empty".localized, fieldName))
        }
        if let min = minimumLength, string.characters.count < min {
            return (false, String(format: "less.than.characters".localized, fieldName, min))
        }
        if let format = format {
            let predicate = NSPredicate(format: "SELF MATCHES %@", format)
            if !predicate.evaluate(with: string) {
                return (false, String(format: "format.is.invalid".localized, fieldName))
            }
        }
        if let second = compareWith, second.compareString != string {
            return (false, String(format: "isLike".localized,
                                    fieldName, second.compareFieldName.lowercased()))
        }
        return (true, string)
    }
    
}
