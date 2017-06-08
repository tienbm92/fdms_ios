//
//  DeviceAssignment.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 5/26/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

struct DeviceAssignment: Mappable {
    
    var productName: String = ""
    var deviceCategory: String = ""
    var invoiceNumber: String?
    var image: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        productName <- map["product_name"]
        deviceCategory <- map["device_category"]
        invoiceNumber <- map["invoice_number"]
        image <- map["image"]
    }
}
