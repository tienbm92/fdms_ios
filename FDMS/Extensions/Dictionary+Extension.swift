//
//  Dictionary+Extension.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/21/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func toHttpFormDataString() -> String {
        var resultDictionary = Dictionary()
        for (key, value) in self {
            if let valueDict = value as? Dictionary {
                makeDict(startKey: key, resultDictionary: &resultDictionary,
                         source: valueDict)
            } else {
                resultDictionary[key] = value
            }
        }
        var formDataString = ""
        for (key, value) in resultDictionary {
            formDataString += "&\(key)=\(value)"
        }
        if !formDataString.isEmpty {
            formDataString.remove(at: formDataString.startIndex)
        }
        return formDataString
    }
    
    private func makeDict(startKey: Key, resultDictionary: inout Dictionary,
                          source: Dictionary) {
        for (key, value) in source {
            let keyString = "\(startKey)[\(key)]"
            if let newKey = keyString as? Key {
                if let valueDict = value as? Dictionary {
                    makeDict(startKey: newKey, resultDictionary: &resultDictionary,
                             source: valueDict)
                } else {
                    resultDictionary[newKey] = value
                }
            }
        }
    }
    
    func convertDictToJson() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return jsonString
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
}
