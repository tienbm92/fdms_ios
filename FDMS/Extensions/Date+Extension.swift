//
//  Date+Extension.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/25/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

extension Date {
    
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
}
