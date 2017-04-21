//
//  ManagerValue.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 4/23/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class ManagerValue: Mappable {
    var valueId: Int = 0
    var name: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        valueId <- map["id"]
        name <- map["name"]
    }
    
}
