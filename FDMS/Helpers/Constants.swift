//
//  Constants.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Alamofire
import Foundation

// MARK: - Constants for LoginViewController

let kLoggedInUserKey = "com.framgia.FDMS.loggedInUserJSON"

// MARK: - Constants for Cell Id
let buttonCellId = "ButtonCell"
let kInfoDeviceRequestCell = "InfoDeviceRequestCell"
let kPieChartCell = "PieChartCell"
let kTopRequestTitleCell = "TopRequestTitleCell"
let kTopRequestCell = "TopRequestCell"
let kTopDeviceTitleCell = "TopDeviceTitleCell"
let kTopDeviceCell = "TopDeviceCell"
let kDeviceHistoryTitleCell = "DeviceHistoryTitle"
let kDeviceHistoryCell = "DeviceHistory"
let kDeviceUsingTitleCell = "DeviceUsingTitle"
let kDeviceUsingCell = "DeviceUsing"
let kManageRequestCell = "ManageRequestCell"
let kInfoRequestCell = "InfoRequestCell"
let kDevicesRequestCell = "DevicesRequestCell"
let kDevicesAssignmentCell = "DevicesAssignmentCell"
let kListTopDevicesCell = "ListTopDevicesCell"
let kListTopRequestsCell = "ListTopRequestsCell"

// MARK: - Constants for API

let kFramgiaURL = "http://stg-dms.framgia.vn"
let kBaseURL = "http://stg-dms.framgia.vn/api/v1/"
let kYourRequestsURL = "\(kBaseURL)requests"
let kManageRequestsURL = "\(kBaseURL)requests?manager_request=1"
let kDeviceCategoriesURL = "\(kBaseURL)device_categories"
let kRequestStatusURL = "\(kBaseURL)request_status"
let kUserGroupURL = "\(kBaseURL)user_group"
let kDeviceCodeURL = "\(kBaseURL)device_code"
let kDevicesURL = "\(kBaseURL)devices"
let kDevicesStatus = "\(kBaseURL)device_status"
let kSignInURL = "\(kBaseURL)sessions"
let kAssignToURL = "\(kBaseURL)user_assign"
let kRelativeToURL = "\(kBaseURL)user_group"
let kDeviceDashboad = "\(kBaseURL)device_dashboard"
let kRequestDashboad = "\(kBaseURL)request_dashboard"
let kTopRequests = "\(kRequestDashboad)?top_requests=1"
let kTopDevices = "\(kDeviceDashboad)?top_devices=1"
let kDeviceUsing = "\(kBaseURL)device_using"
let kDeviceHistory = "\(kBaseURL)device_history"
let kTimeOut: TimeInterval = 60

// MARK: - Constants for DataValidator

let kEmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
let kMinimumPasswordLength = 6

// MARK: - Constants for Date Time Format

let kDateFormat = "yyyy/MM/dd"
let kTimeFormat = "HH:mm:ss"
let kDateFormatTimeZone = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
