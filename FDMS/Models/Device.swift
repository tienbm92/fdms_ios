//
//  Device.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/20/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

struct Device {
    var deviceId: Int?
    var deviceCode: String?
    var productionName: String = ""
    var deviceStatusId: Int?
    var deviceCategoryId: Int?
    var requestFor: String = ""
    var picture: String?
    var originalPrice: Int = 0
    var boughtDate: Date?
    var printedCode: String = ""
    var isBarcode: Bool = false
    var deviceStatusName: String = ""
    var deviceCategoryName: String = ""
}
