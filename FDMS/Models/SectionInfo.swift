//
//  SectionInfo.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/19/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class SectionInfo: NSObject {
    
    var titleForHeader: String?
    var heightForHeader: CGFloat?
    var heightForFooter: CGFloat?
    var cells: [CellInfo] = [CellInfo]()
    
    convenience init(titleForHeader: String?, heightForHeader: CGFloat?, heightForFooter: CGFloat?,
                     constructor: () -> ([CellInfo])) {
        self.init()
        self.titleForHeader = titleForHeader
        self.heightForHeader = heightForHeader
        self.heightForFooter = heightForFooter
        self.cells = constructor()
    }

}
