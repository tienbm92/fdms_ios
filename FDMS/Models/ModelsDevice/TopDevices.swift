//
//  TopDevices.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 6/6/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

struct TopDevice: Mappable {
    
    var name: String = ""
    var status: Int = 0
    var summary: Summary?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        status <- map["status"]
        summary <- map["summary"]
    }
    
}
