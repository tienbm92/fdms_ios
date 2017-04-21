//
//  String+Extension.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 3/31/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Alamofire
import Foundation

extension String: ParameterEncoding {

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
