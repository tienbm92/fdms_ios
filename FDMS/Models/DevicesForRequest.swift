//
//  DevicesForRequest.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/27/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

struct DevicesForRequest: Mappable {
    
    var deviceId: Int?
    var description: String = ""
    var number: Int = 0
    var categoryName: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        deviceId <- map["id"]
        description <- map["description"]
        number <- map["number"]
        categoryName <- map["category_name"]
    }
    
}
