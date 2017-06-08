//
//  Summary.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 6/6/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

struct Summary: Mappable {
    
    var assignment: Int = 0
    var available: Int = 0
    var total: Int = 0
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        assignment <- map["assignment"]
        available <- map["available"]
        total <- map["total"]
    }
    
}
