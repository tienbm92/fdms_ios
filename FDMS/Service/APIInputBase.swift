//
//  APIInputBase.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 6/7/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Alamofire
import Foundation

class APIInputBase {
    
    let headers: HTTPHeaders = ["Authorization": "\(DataStore.shared.currentToken)", "Accept": "application/json"]
    let urlString: String
    let requestType: HTTPMethod
    let encoding: ParameterEncoding
    let param: [String: Any]?
    
    init(urlString: String, param: [String: Any]?, requestType: HTTPMethod) {
        self.urlString = urlString
        self.requestType = requestType
        self.param = param
        self.encoding = URLEncoding.default
    }
    
}
