//
//  FilterInfo.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/28/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class FilterInfo {

    var name: String = ""
    var objectId: Int = 0
    
    convenience init(objectId: Int, name: String) {
        self.init()
        self.objectId = objectId
        self.name = name
    }
}
