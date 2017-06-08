//
//  Request.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 4/22/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class Request: Mappable {
    var requestId: Int?
    var title: String = ""
    var description: String = ""
    var requestStatus: String?
    var requestStatusId: Int = 0
    var assignee: String?
    var assigneeId: Int = 0
    var requestFor: String?
    var requestForId: Int = 0
    var creater: String = ""
    var updater: String = ""
    var createAt: Date?
    var updateAt: Date?
    var devices: [DevicesForRequest]?
    var devicesAssignment: [DeviceAssignment]?
    var listAction: [OtherObject]?
    
    init?(title: String?, description: String?, assignToId: Int?, requestForId: Int?, devices: [DevicesForRequest]?) {
        guard let title = title, let description = description, let requestForId = requestForId,
            let assignToId = assignToId else {
            return nil
        }
        self.title = title
        self.description = description
        self.assigneeId = assignToId
        self.requestForId = requestForId
        self.devices = devices
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        requestId <- map["id"]
        title <- map["title"]
        description <- map["description"]
        requestStatus <- map["request_status"]
        assignee <- map["assignee"]
        requestFor <- map["request_for"]
        creater <- map["creater"]
        updater <- map["updater"]
        createAt <- (map["created_at"], DateTransformCustom(dateFormat: kDateFormatTimeZone))
        updateAt <- (map["updated_at"], DateTransformCustom(dateFormat: kDateFormatTimeZone))
        devices <- map["devices"]
        devicesAssignment <- map["device_assignment"]
        listAction <- map["list_action"]
    }
    
}
