//
//  CellInfo.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/19/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class CellInfo: NSObject {
    
    var indentifier: String?
    var heightForRow: CGFloat?
    
    convenience init(indentifier: String?, heightForRow: CGFloat?) {
        self.init()
        self.indentifier = indentifier
        self.heightForRow = heightForRow
    }
    
}
