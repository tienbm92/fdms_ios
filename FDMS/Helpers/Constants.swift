//
//  Constants.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Alamofire
import Foundation

let buttonCellId = "ButtonCell"
let infoDeviceRequestCell = "InfoDeviceRequestCell"
let kPieChartCell = "PieChartCell"
let kTopRequestTitleCell = "TopRequestTitleCell"
let kTopRequestCell = "TopRequestCell"
let kTopDeviceTitleCell = "TopDeviceTitleCell"
let kTopDeviceCell = "TopDeviceCell"

// MARK: - Constants for API

let kBaseURL = "http://stg-dms.framgia.vn/api/v1/"
let kRequestsURL = "\(kBaseURL)requests"
let kDeviceCategoriesURL = "\(kBaseURL)device_categories"
let kRequestStatusURL = "\(kBaseURL)request_status"
let kUserGroupURL = "\(kBaseURL)user_group"
let kDeviceCodeURL = "\(kBaseURL)device_code"
let kDevicesURL = "\(kBaseURL)devices"
let kDevicesStatus = "\(kBaseURL)device_status"
let headers: HTTPHeaders = ["Authorization": "\(DataStore.shared.currentToken)", "Accept": "application/json"]
let kSignInURL = "\(kBaseURL)sessions"

// MARK: - Constants for DataValidator

let kEmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
let kMinimumPasswordLength = 6
