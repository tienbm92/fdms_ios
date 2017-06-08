//
//  Array+Extension.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 6/5/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

extension Array {
    
    func convertArrayToJsonString() -> [String]? {
        var result = [String]()
        for index in 0..<self.count {
            if let elementDict = self[index] as? [String: Any], let elementString = elementDict.convertDictToJson() {
                result.append(elementString)
            } else {
                return nil
            }
        }
        return  result.isEmpty ? nil : result
    }
    
}
