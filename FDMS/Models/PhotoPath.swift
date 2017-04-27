//
//  PhotoPath.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/26/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

struct PhotoPath: Mappable {
    
    var photoURL: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        photoURL <- map["url"]
        
    }
}
