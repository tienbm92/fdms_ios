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
    var categoryId: Int = 0
    
    init?(deviceId: Int?, description: String?, number: Int?, categoryName: String?, categoryId: Int?) {
        guard let description = description, let number = number, let categoryName = categoryName,
            let categoryId = categoryId else {
            return
        }
        self.deviceId = deviceId
        self.description = description
        self.number = number
        self.categoryName = categoryName
        self.categoryId = categoryId
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        deviceId <- map["id"]
        description <- map["description"]
        number <- map["number"]
        categoryName <- map["category_name"]
    }
    
    func buildDeviceForUpdate() -> [String: String] {
        var param = [String: String]()
        param = ["description": self.description, "device_category_id": "\(self.categoryId)", "number": "\(number)"]
        return param
    }
    
}
