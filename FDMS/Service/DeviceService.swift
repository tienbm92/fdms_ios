//
//  DeviceService.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/24/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Alamofire
import Foundation

enum OptionGetURL {
    case getRquestStatus
    case getDeviceStatus
    case getDeviceCategories
    case getDeviceByCode
    case getDeviceById
    case getAssignTo
    case getRelativeTo
    case getDeviceDashboad
    case getRequestDashboad
    case getDevices
    case getTopDevices
    case getDeviceUsing
    case getDeviceHistory
    
    func toStringURL() -> String {
        switch self {
        case .getRquestStatus:
            return kRequestStatusURL
        case .getDeviceStatus:
            return kDevicesStatus
        case .getDeviceCategories:
            return kDeviceCategoriesURL
        case .getAssignTo:
            return kAssignToURL
        case .getRelativeTo:
            return kRelativeToURL
        case .getDeviceDashboad:
            return kDeviceDashboad
        case .getRequestDashboad:
            return kRequestDashboad
        case .getDevices:
            return kDevicesURL
        case .getTopDevices:
            return kTopDevices
        case .getDeviceByCode, .getDeviceById:
            return kDeviceCodeURL
        case .getDeviceUsing:
            return kDeviceUsing
        case .getDeviceHistory:
            return kDeviceHistory
        }
    }
}

enum CompletionResult {
    case success(Any)
    case failure(Error)
}

enum OptionParser {
    case parserGetListDevice
    case parserGetDevice
    case parserGetOtherObject
    case parserGetRequests
    case parserUpdateOrAddRequest
    case parserGetDashboad
    case parserGetTopDevices
    case parserGetTopRequest
    case parserGetDevicesOther
}

class DeviceService: APIService {
    
    static let shared: DeviceService = DeviceService()
    fileprivate var totalPages: Int = 0
    fileprivate var errorInfo: ErrorInfo?
    fileprivate var optionParser: OptionParser = .parserGetDevice
    
    func getTotalPages() -> Int {
        return totalPages
    }
    
    func getMessage() -> String {
        if let errorInfo = self.errorInfo {
            return errorInfo.message
        } else {
            return ""
        }
    }
    
    func getListDevices(CategoryID categoryID: Int?, StatusID statusID: Int?,
                        Page page: Page, completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserGetListDevice
        if let urlRequest = self.createParamGetListDevices(categoryID: categoryID, statusID: statusID, page: page) {
            doExecuteGetRequest(urlReuqest: urlRequest, completion: { (result, _) in
                if let result = result {
                    completion(.success(result))
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                }
            })
        } else {
            completion(.failure(APIServiceError.errorParseJSON))
        }
    }
    
    func getOtherObject(OptionGet option: OptionGetURL, completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserGetOtherObject
        if let urlRequest = self.createParamGetOtherObject(OptionGet: option) {
            doExecuteGetRequest(urlReuqest: urlRequest, completion: { (result, _) in
                if let result = result {
                    completion(.success(result))
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                }
            })
        } else {
            completion(.failure(APIServiceError.errorParseJSON))
        }
    }
    
    func getDevice(optionGet option: OptionGetURL, DeviceId deviceId: Int = 0,
                   PrintedCode printedCode: String = "", completion: @escaping (CompletionResult) -> Void) {
        switch option {
        case .getDeviceUsing, .getDeviceHistory:
            self.optionParser = .parserGetDevicesOther
        case .getDeviceById, .getDeviceByCode:
            self.optionParser = .parserGetDevice
        default:
            return
        }
        if let urlRequest = self.createParamGetDevice(option: option, deviceId: deviceId, printedCode: printedCode) {
            doExecuteGetRequest(urlReuqest: urlRequest, completion: { (result, _) in
                if let result = result {
                    completion(.success(result))
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                }
            })
        }
    }
    
    func getDashboad(OptionGet option: OptionGetURL, completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserGetDashboad
        if let urlRequest = self.createParamGetOtherObject(OptionGet: option) {
            doExecuteGetRequest(urlReuqest: urlRequest, completion: { (result, _) in
                if let result = result {
                    completion(.success(result))
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                }
            })
        } else {
            completion(.failure(APIServiceError.errorParseJSON))
        }
    }
    
    func getTopDevices(completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserGetTopDevices
        if let urlRequest = self.createParamGetOtherObject(OptionGet: .getTopDevices) {
            doExecuteGetRequest(urlReuqest: urlRequest, completion: { (result, _) in
                if let result = result {
                    completion(.success(result))
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                }
            })
        } else {
            completion(.failure(APIServiceError.errorParseJSON))
        }
    }
    
    private func createParamGetListDevices(categoryID: Int?, statusID: Int?, page: Page) -> URLRequest? {
        var paramDefault = ["page": "\(page.page)", "per_page": "\(page.perPage)"]
        var param = [String: String]()
        if let category = categoryID, let status = statusID {
            param = ["category_id": "\(category)", "status_id": "\(status)"]
        } else if let category = categoryID {
            param = ["category_id": "\(category)"]
        } else if let status = statusID {
            param = ["status_id": "\(status)"]
        }
        paramDefault.merge(with: param)
        if let paramResult = addRequestParams(dict: paramDefault),
            let urlRequest = asGetRequest(parameters: paramResult.origin(), url: kDevicesURL) {
            return urlRequest
        } else {
            return nil
        }
    }
    
    override func onFinish(_ response: Any?, statusCode: Int, error: ErrorInfo?,
                           completion: NetworkServiceCompletion?) {
        let dataResult: Any?
        if let result = response, let error = error {
            dataResult = self.handleParser(optionParser: self.optionParser, data: result, error: error)
            self.errorInfo = error
            super.onFinish(dataResult, error: error, completion: completion)
        } else {
            super.onFinish(nil, error: nil, completion: completion)
        }
    }
    
    private func handleParser(optionParser: OptionParser, data: Any, error: ErrorInfo) -> Any? {
        switch optionParser {
        case .parserGetListDevice:
            return self.parserGetListDevice(data: data, error: error)
        case .parserGetDevice:
            return self.parserGetDevice(data: data, error: error)
        case .parserGetOtherObject:
            return self.parserGetOtherObject(data: data, error: error)
        case .parserGetDashboad:
            return self.parserGetDashboad(data: data, error: error)
        case .parserGetTopDevices:
            return self.parserGetTopDevices(data: data, error: error)
        default:
            return nil
        }
    }
    
    private func parserGetListDevice(data: Any?, error: ErrorInfo?) -> [Device]? {
        guard let response = data, let error = error,
            let result = JsonParser.share.callToParser(option: .parserRawToArray, dataJson: response),
            let data = result.dataArray, let totalPages = result.totalPages else {
                return nil
        }
        if error.status == StatusCode.notFound.rawValue {
            return nil
        }
        self.totalPages = totalPages
        var listDevices = [Device]()
        for device in data {
            let device = Device(JSON: device)
            if let device = device {
                listDevices.append(device)
            } else {
                return nil
            }
        }
        if listDevices.isEmpty {
            return nil
        } else {
            return listDevices
        }
    }
    
    private func createParamGetOtherObject(OptionGet option: OptionGetURL) -> URLRequest? {
        if let urlRequest = asGetRequest(parameters: nil, url: option.toStringURL()) {
            return urlRequest
        }
        return nil
    }
    
    private func parserGetOtherObject(data: Any?, error: ErrorInfo?) -> [OtherObject]? {
        guard let response = data, let error = error,
            let result = JsonParser.share.callToParser(option: .parserRawNoTotalPages, dataJson: response),
            let data = result.dataArray else {
                return nil
        }
        if error.status != 200 {
            return nil
        }
        var listResult = [OtherObject]()
        for result in data {
            let result = OtherObject(JSON: result)
            if let result = result {
                listResult.append(result)
            } else {
                return nil
            }
        }
        if listResult.isEmpty {
            return nil
        } else {
            return listResult
        }
    }
    
    private func createParamGetDevice(option: OptionGetURL, deviceId: Int, printedCode: String) -> URLRequest? {
        var paramInfo = [String: String]()
        var url = ""
        switch option {
        case .getDeviceByCode:
            paramInfo = ["printed_code": "\(printedCode)"]
            url = option.toStringURL()
        case .getDeviceById:
            paramInfo = ["device_id": "\(deviceId)"]
            url = option.toStringURL()
        case .getDeviceUsing, .getDeviceHistory:
            url = option.toStringURL() + "/\(deviceId)"
        default:
            return nil
        }
        if option == .getDeviceHistory || option == .getDeviceUsing {
            return asGetRequest(parameters: nil, url: url)
        } else if let param = addRequestParams(dict: paramInfo),
            let urlRequest = asGetRequest(parameters: param.origin(), url: kDeviceCodeURL) {
            return urlRequest
        } else {
            return nil
        }
    }
    
    private func parserGetDevice(data: Any?, error: ErrorInfo?) -> Device? {
        guard let response = data, let error = error,
            let result = JsonParser.share.callToParser(option: .parserRawToObject, dataJson: response),
            let data = result.dataObject else {
                return nil
        }
        if error.status != 200 {
            return nil
        }
        let deviceResult = Device(JSON: data)
        if let deviceResult = deviceResult {
            return deviceResult
        } else {
            return nil
        }
    }
    
    private func parserGetDashboad(data: Any?, error: ErrorInfo?) -> [Dashboard]? {
        guard let response = data, let error = error,
            let result = JsonParser.share.callToParser(option: .parserRawNoTotalPages, dataJson: response),
            let data = result.dataArray else {
            return nil
        }
        if error.status != 200 {
            return nil
        }
        var dashboadResult = [Dashboard]()
        for result in data {
            let dashboad = Dashboard(JSON: result)
            if let dashboad = dashboad {
                dashboadResult.append(dashboad)
            } else {
                return nil
            }
        }
        if dashboadResult.isEmpty {
            return nil
        } else {
            return dashboadResult
        }
    }
    
    private func parserGetTopDevices(data: Any?, error: ErrorInfo?) -> [TopDevice]? {
        guard let response = data, let error = error,
            let result = JsonParser.share.callToParser(option: .parserRawNoTotalPages, dataJson: response),
            let data = result.dataArray else {
            return nil
        }
        if error.status != 200 {
            return nil
        }
        var topDevices = [TopDevice]()
        for item in data {
            let device = TopDevice(JSON: item)
            if let device = device {
                topDevices.append(device)
            } else {
                return nil
            }
        }
        if topDevices.isEmpty {
            return nil
        } else {
            return topDevices
        }
    }
    
    private func parserGetDevicesOther(data: Any?, error: ErrorInfo?) -> [Device]? {
        guard let response = data, let error = error,
            let result = JsonParser.share.callToParser(option: .parserRawNoTotalPages, dataJson: response),
            let data = result.dataArray else {
            return nil
        }
        if error.status != 200 {
            return nil
        }
        var devices = [Device]()
        for item in data {
            let device = Device(JSON: item)
            if let device = device {
                devices.append(device)
            } else {
                return nil
            }
        }
        if devices.isEmpty {
            return nil
        } else {
            return devices
        }
    }
    
}

extension DeviceService {
    
    func percentageForDashboard(_ dashboard: [Dashboard]) -> [String] {
        var result = [String]()
        var sumCount = 0.00
        var percent = 0.00
        for index in 0..<dashboard.count {
            sumCount = sumCount + dashboard[index].count
        }
        for i in 0..<dashboard.count {
            percent = dashboard[i].count / sumCount * 100
            let percentInt = Int(percent)
            let resultElement = dashboard[i].title + " " + "\(percentInt)" + "%"
            result.append(resultElement)
        }
        return result
    }
    
}
