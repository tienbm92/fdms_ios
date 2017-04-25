//
//  User.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/18/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class User {
    var uid: Int?
    var name: String = ""
    var address: String = ""
    var email: String?
    var password: String?
    var deparmentId: Int = 0
    var avatar: String = ""
    var token: String?
    var rememberMe: Bool = false
    
    init() {
    }
    
}
