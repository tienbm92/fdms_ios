//
//  DateTransformCustom.swift
//  FDMS
//
//  Created by Bùi Minh Tiến on 5/22/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class DateTransformCustom: DateFormatterTransform {
    
    private var valueDateFormatter: DateFormatter = DateFormatter()
    
    init(dateFormat: String) {
        self.valueDateFormatter.dateFormat = dateFormat
        super.init(dateFormatter: valueDateFormatter)
    }
    
}
