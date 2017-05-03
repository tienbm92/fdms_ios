//
//  DeviceService.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/24/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Alamofire
import Foundation

enum optionGetURL {
    case getRquestStatus
    case getDeviceStatus
    case getDeviceCategories
    case getDeviceByCode
    case getDeviceById
}

enum ListDeviceResult {
    case success([Device])
    case failure(Error)
}

enum DeviceResult {
    case success(Device)
    case failure(Error)
}

class DeviceService {
    
    static let shared: DeviceService = DeviceService()
    fileprivate lazy var totalPages: Int = 0
    
    func getTotalPages() -> Int {
        return totalPages
    }
    
    func getListDevices(CategoryID categoryID: Int?, StatusID statusID: Int?,
                        Page page: Page, completion: @escaping (ListDeviceResult) -> Void) {
        var infoDict = [String: String]()
        if let categoryID = categoryID, let statusID = statusID {
            infoDict = ["category_id": "\(categoryID)", "status_id": "\(statusID)",
                "page": "\(page.page)", "per_page": "\(page.perPage)"]
        } else {
            infoDict = ["page": "\(page.page)", "per_page": "\(page.perPage)"]
        }
        Alamofire.request(kDevicesURL, method: .get, parameters: infoDict,
                          headers: headers).responseJSON { (response) in
            guard let jsonInput = response.result.value else {
                completion(.failure(APIServiceError.errorSystem))
                return
            }
            let (status, data, totalPagesResult) = JsonParser.share.parserRawToArray(JsonInput: jsonInput)
            if status == APIServiceError.errorNotFound {
                completion(.failure(APIServiceError.errorNotFound))
            } else if status == APIServiceError.normal {
                guard let totalPagesResult = totalPagesResult,
                    let data = data else {
                    completion(.failure(APIServiceError.errorParseJSON))
                    return
                }
                self.totalPages = totalPagesResult
                var listDevices = [Device]()
                for device in data {
                    let device = Device(JSON: device)
                    if let device = device {
                        listDevices.append(device)
                    } else {
                        completion(.failure(APIServiceError.errorParseJSON))
                    }
                }
                if listDevices.isEmpty {
                    completion(.failure(APIServiceError.errorNotFound))
                } else {
                    completion(.success(listDevices))
                }
            } else {
                completion(.failure(APIServiceError.errorSystem))
            }
        }
        
    }
    
    func getOtherObject(OptionGet option: optionGetURL, completion: @escaping (OtherObjectResult) -> Void) {
        var getURL = ""
        switch option {
        case .getDeviceCategories:
            getURL = kDeviceCategoriesURL
        case .getDeviceStatus:
            getURL = kDevicesStatus
        case .getRquestStatus:
            getURL = kRequestStatusURL
        default:
            completion(.failure(APIServiceError.errorParseJSON))
            return
        }
        Alamofire.request(getURL, method: .get, headers: headers).responseJSON { (response) in
            guard let jsonInput = response.result.value else {
                completion(.failure(APIServiceError.errorSystem))
                return
            }
            let (status, data) = JsonParser.share.parserRawNoTotalPages(JsonInput: jsonInput)
            if status == APIServiceError.errorNotFound {
                completion(.failure(APIServiceError.errorNotFound))
            }
            guard let dataResult = data else {
                completion(.failure(APIServiceError.errorParseJSON))
                return
            }
            var listResult = [OtherObject]()
            for result in dataResult {
                let result = OtherObject(JSON: result)
                if let result = result {
                    listResult.append(result)
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                    return
                }
            }
            if listResult.isEmpty {
                completion(.failure(APIServiceError.errorNotFound))
            } else {
                completion(.success(listResult))
            }
        }
    }
    
    func getDevice(optionGet option: optionGetURL, DeviceId deviceId: Int = 0,
                   PrintedCode printedCode: String = "", completion: @escaping (DeviceResult) -> Void) {
        var infoDict = [String: String]()
        switch option {
        case .getDeviceByCode:
            infoDict = ["printed_code": "\(printedCode)"]
        case .getDeviceById:
            infoDict = ["device_id": "\(deviceId)"]
        default:
            completion(.failure(APIServiceError.errorParseJSON))
            return
        }
        Alamofire.request(kDeviceCodeURL, method: .get, parameters: infoDict,
                          headers: headers).responseJSON { (response) in
            guard let jsonInput = response.result.value else {
                completion(.failure(APIServiceError.errorSystem))
                return
            }
            let (status, data) = JsonParser.share.parserRawToObject(JsonInput: jsonInput)
            if status == APIServiceError.errorNotFound {
                completion(.failure(APIServiceError.errorNotFound))
            } else if status == APIServiceError.normal {
                guard let data = data else {
                    completion(.failure(APIServiceError.errorParseJSON))
                    return
                }
                let deviceResult = Device(JSON: data)
                if let deviceResult = deviceResult {
                    completion(.success(deviceResult))
                } else {
                    completion(.failure(APIServiceError.errorNotFound))
                }
            } else {
                completion(.failure(APIServiceError.errorSystem))
            }
        }
    }
    
}
