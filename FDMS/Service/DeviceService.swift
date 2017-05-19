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
    case getAssignTo
    case getRelativeTo
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
            doExecuteGetRequest(urlReuqest: urlRequest, completion: { [weak self] (result, error) in
                if let result = result, let error = error {
                    self?.errorInfo = error
                    completion(.success(result))
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                }
            })
        } else {
            completion(.failure(APIServiceError.errorParseJSON))
        }
    }
    
    func getOtherObject(OptionGet option: optionGetURL, completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserGetOtherObject
        if let urlRequest = self.createParamGetOtherObject(OptionGet: option) {
            doExecuteGetRequest(urlReuqest: urlRequest, completion: { (result, error) in
                if let result = result, let _ = error {
                    completion(.success(result))
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                }
            })
        } else {
            completion(.failure(APIServiceError.errorParseJSON))
        }
    }
    
    func getDevice(optionGet option: optionGetURL, DeviceId deviceId: Int = 0,
                   PrintedCode printedCode: String = "", completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserGetDevice
        if let urlRequest = self.createParamGetDevice(option: option, deviceId: deviceId, printedCode: printedCode) {
            doExecuteGetRequest(urlReuqest: urlRequest, completion: { (result, error) in
                if let result = result, let _ = error {
                    completion(.success(result))
                } else {
                    completion(.failure(APIServiceError.errorParseJSON))
                }
            })
        }
    }
    
    private func createParamGetListDevices(categoryID: Int?, statusID: Int?, page: Page) -> URLRequest? {
        var paramDefault = ["page": "\(page.page)", "per_page": "\(page.perPage)"]
        var param = [String: String]()
        if let category = categoryID, let status = statusID {
            param = ["category_id": "\(category)", "status_id": "\(status)"]
        }
        if let category = categoryID {
            param = ["category_id": "\(category)"]
        } else if let status = statusID {
            param = ["status_id": "\(status)"]
        }
        paramDefault.merge(with: param)
        if let paramResult = addRequestParams(dict: paramDefault),
           let urlRequest = asGetRequest(parameters: paramResult.origin(), url: kDevicesURL) {
            return urlRequest
        }
        return nil
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
    
    private func createParamGetOtherObject(OptionGet option: optionGetURL) -> URLRequest? {
        var getURL = ""
        switch option {
        case .getDeviceCategories:
            getURL = kDeviceCategoriesURL
        case .getDeviceStatus:
            getURL = kDevicesStatus
        case .getRquestStatus:
            getURL = kRequestStatusURL
        case .getAssignTo:
            getURL = kAssignToURL
        case .getRelativeTo:
            getURL = kRelativeToURL
        default:
            return nil
        }
        if let urlRequest = asGetRequest(parameters: nil, url: getURL) {
            return urlRequest
        }
        return nil
    }
    
    private func parserGetOtherObject(data: Any?, error: ErrorInfo?) -> [OtherObject]? {
        guard let response = data, let error = error,
            let result = JsonParser.share.parserRawNoTotalPages(JsonInput: response),
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
    
    private func createParamGetDevice(option: optionGetURL, deviceId: Int, printedCode: String) -> URLRequest? {
        var paramInfo = [String: String]()
        switch option {
        case .getDeviceByCode:
            paramInfo = ["printed_code": "\(printedCode)"]
        case .getDeviceById:
            paramInfo = ["device_id": "\(deviceId)"]
        default:
            return nil
        }
        if let param = addRequestParams(dict: paramInfo),
           let urlRequest = asGetRequest(parameters: param.origin(), url: kDeviceCodeURL) {
            return urlRequest
        } else {
            return nil
        }
    }
    
    private func parserGetDevice(data: Any?, error: ErrorInfo?) -> Device? {
        guard let response = data, let error = error,
            let result = JsonParser.share.parserRawToObject(JsonInput: response),
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
    
}
