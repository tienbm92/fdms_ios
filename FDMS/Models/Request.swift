//
//  Request.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/18/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

struct Request {
    var requestId: Int = 0
    var title: String = ""
    var description: String = ""
    var requestStatus: String = ""
    var assignee: String = ""
    var requestFor: String = ""
    var creater: String = ""
    var updater: String = ""
    var devices: [Device] = [Device]()
}
