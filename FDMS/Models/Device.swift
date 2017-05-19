//
//  Device.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/20/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class Device: Mappable {
    
    var deviceId: Int?
    var deviceCode: String?
    var productionName: String = ""
    var modelNumber: String = ""
    var serialNumber: String = ""
    var deviceStatusId: Int?
    var deviceCategoryId: Int?
    var picture: PhotoPath?
    var originalPrice: Int = 0
    var boughtDate: Date?
    var printedCode: String = ""
    var isBarcode: Bool = false
    var deviceStatusName: String = ""
    var deviceCategoryName: String = ""
    
    init() {
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        deviceId <- map["id"]
        deviceCode <- map["device_code"]
        productionName <- map["production_name"]
        deviceStatusId <- map["device_status_id"]
        deviceCategoryId <- map["device_category_id"]
        picture <- map["picture"]
        originalPrice <- map["original_price"]
        boughtDate <- (map["bought_date"], DateTransformCustom(dateFormat: kDateFormat))
        printedCode <- map["printed_code"]
        isBarcode <- map["is_barcode"]
        deviceStatusName <- map["device_status_name"]
        deviceCategoryName <- map["device_category_name"]
    }
    
    func getImageURL() -> URL? {
        return URL(string: "\(kFramgiaURL)\(picture?.photoURL ?? "")")
    }
    
}
