//
//  RequestParams.swift
//  FDMS
//
//  Created by Bui Minh Tien on 5/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class RequestParams: NSObject {
    var params: [String: Any] = [String: Any]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if let vl = value {
            params[key] = vl
        }
    }
    
    func origin() -> [String : Any] {
        return params
    }
    
}
