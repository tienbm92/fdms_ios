//
//  Dictionary+Extension.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/21/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func stringForKey(_ key: Key) -> String? {
        return self[key] as? String
    }
    
    func boolForKey(_ key: Key) -> Bool? {
        return self[key] as? Bool
    }
    
    func intForKey(_ key: Key) -> Int? {
        return self[key] as? Int
    }
    
    func floatForKey(_ key: Key) -> Float? {
        return self[key] as? Float
    }
    
    func doubleForKey(_ key: Key) -> Double? {
        return self[key] as? Double
    }
    
    func arrayForKey(_ key: Key) -> [Any]? {
        return self[key] as? [Any]
    }
    
    func dictionaryForKey(_ key: Key) -> [AnyHashable: Any]? {
        return self[key] as? [AnyHashable: Any]
    }
    
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
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
}
