//
//  Dashboad.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 5/18/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

struct Dashboard: Mappable {
    
    var title: String = ""
    var count: Double = 0.00
    var color: String = ""
    var backgroundColor: UIColor?
    var hoverBackgroundColor: UIColor?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        count <- map["count"]
        color <- map["color"]
        backgroundColor <- (map["background_color"], HexColorTransform())
        hoverBackgroundColor <- (map["hover_background_color"], HexColorTransform())
    }

}
