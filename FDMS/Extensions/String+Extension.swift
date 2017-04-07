//
//  String+Extension.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 3/31/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
}
