//
//  Request.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 4/22/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

struct Request: Mappable {
    var requestId: Int?
    var title: String?
    var description: String = ""
    var requestStatus: String?
    var assignee: String = ""
    var requestFor: String?
    var creater: String = ""
    var updater: String = ""
    var devices: [Device] = [Device]()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        requestId <- map["id"]
        title <- map["title"]
        description <- map["description"]
        requestStatus <- map["request_status"]
        assignee <- map["assignee"]
        requestFor <- map["request_for"]
        creater <- map["creater"]
        updater <- map["updater"]
        devices <- map["devices"]
    }
    
}
