//
//  DataStore.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/21/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class DataStore {
    
    static let shared: DataStore = DataStore()
    var requests: [Request] = [Request]()
    var device: [Device] = [Device]()
    var currentToken: String = ""
    var user: User?
    
}
