//
//  ParserResult.swift
//  FDMS
//
//  Created by Bui Minh Tien on 5/11/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

struct ParserResult {
    var status: APIServiceError = APIServiceError.errorParseJSON
    var dataObject: [String: Any]?
    var dataArray: [[String: Any]]?
    var totalPages: Int?
    var token: String?
}
