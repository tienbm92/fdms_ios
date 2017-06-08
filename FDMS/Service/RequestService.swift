//
//  RequestService.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/21/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Alamofire
import Foundation

enum optionActionRequest {
    case updateRequest
    case addRequest
}

enum optionGetRequests {
    case manageRequests
    case yourRequests
    case topRequest
    
    func toStringURL() -> String {
        switch self {
        case .manageRequests:
            return kManageRequestsURL
        case .yourRequests:
            return kYourRequestsURL
        case .topRequest:
            return kTopRequests
        }
    }
}

class RequestService: APIService {
    
    static let share: RequestService = RequestService()
    fileprivate var totalPages: Int = 0
    fileprivate var errorInfo: ErrorInfo?
    fileprivate var optionParser: OptionParser = .parserGetRequests
    
    func getTotalPages() -> Int {
        return totalPages
    }
    
    func getMessage() -> String {
        if let error = self.errorInfo {
            return error.message
        } else {
            return ""
        }
    }
    
    func getListRequests(option: optionGetRequests, RequestStatusId statusId: Int?, RelativeID relativeID: Int?,
                         Page page: Page, completion: @escaping (CompletionResult) -> Void) {
        option == .topRequest ? (self.optionParser = .parserGetTopRequest) : (self.optionParser = .parserGetRequests)
        if let urlRequest = self.createUrlRequest(OptionGetRequests: option, RequestStatusId: statusId,
                                                  RelativeID: relativeID, Page: page) {
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
    
    func updateOrAddRequest(OptionActionRequest option: optionActionRequest, RequestUpdate request: Request,
                            device: [DevicesForRequest], completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserUpdateOrAddRequest
        if let apiInput = createParamUpdateOrAddRequest(option: option, request: request, device: device) {
            doExecuteChangeRequest(apiInput, completion: { (result, _) in
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
    
    func updateActionRequest(request: Request, completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserUpdateOrAddRequest
        if let apiInput = createParamUpdateActionRequest(request: request) {
            doExecuteChangeRequest(apiInput, completion: { (result, _) in
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
    
    func getRequestById(requestId: Int, completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserUpdateOrAddRequest
        if let urlRequest = createParamGetRequestById(requestId: requestId) {
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
    
    override func onFinish(_ response: Any?, statusCode: Int, error: ErrorInfo?,
                           completion: NetworkServiceCompletion?) {
        let dataResult: Any?
        if let result = response, let error = error {
            dataResult = self.handleParser(option: self.optionParser, data: result, error: error)
            self.errorInfo = error
            super.onFinish(dataResult, error: error, completion: completion)
        } else {
            super.onFinish(nil, error: nil, completion: completion)
        }
    }
    
    private func handleParser(option: OptionParser, data: Any, error: ErrorInfo) -> Any? {
        switch option {
        case .parserGetRequests:
            return self.parserGetRequests(data: data, error: error)
        case .parserUpdateOrAddRequest:
            return self.parserUpdateOrAddRequest(data: data, error: error)
        case .parserGetTopRequest:
            return self.parserGetTopRequest(data: data, error: error)
        default:
            return nil
        }
    }
    
    private func createUrlRequest(OptionGetRequests option: optionGetRequests, RequestStatusId statusId: Int?,
                                  RelativeID relativeID: Int?, Page page: Page) -> URLRequest? {
        var paramDefault = ["per_page": "\(page.perPage)", "page": "\(page.page)"]
        if let statusId = statusId {
            paramDefault["request_status_id"] = "\(statusId)"
        } else if let relativeID = relativeID {
            paramDefault["relative_id"] = "\(relativeID)"
        }
        if option == .topRequest, let urlRequest = asGetRequest(parameters: nil, url: option.toStringURL()) {
            return urlRequest
        } else {
            if let paramResult = addRequestParams(dict: paramDefault),
                let urlRequest = asGetRequest(parameters: paramResult.origin(), url: option.toStringURL()) {
                return urlRequest
            } else {
                return nil
            }
        }
    }
    
    private func parserGetRequests(data: Any?, error: ErrorInfo?) -> [Request]? {
        guard let responseResult = data, let error = error,
            let result = JsonParser.share.callToParser(option: .parserRawToArray, dataJson: responseResult),
            let data = result.dataArray, let totalPages = result.totalPages else {
                return nil
        }
        if error.status == StatusCode.notFound.rawValue {
            return nil
        }
        self.totalPages = totalPages
        var listRequests = [Request]()
        for requests in data {
            let request = Request(JSON: requests)
            if let request = request {
                listRequests.append(request)
            } else {
                return nil
            }
        }
        if listRequests.isEmpty {
            return nil
        } else {
            return listRequests
        }
    }
    
    private func parserGetTopRequest(data: Any?, error: ErrorInfo?) -> [Request]? {
        guard let responseResult = data, let error = error,
            let result = JsonParser.share.callToParser(option: .parserRawNoTotalPages, dataJson: responseResult),
            let data = result.dataArray else {
                return nil
        }
        if error.status == StatusCode.notFound.rawValue {
            return nil
        }
        var listRequests = [Request]()
        for requests in data {
            let request = Request(JSON: requests)
            if let request = request {
                listRequests.append(request)
            } else {
                return nil
            }
        }
        if listRequests.isEmpty {
            return nil
        } else {
            return listRequests
        }
    }
    
    private func createParamUpdateOrAddRequest(option: optionActionRequest,
                                               request: Request, device: [DevicesForRequest]) -> APIInputBase? {
        var url = ""
        var actionMethod = HTTPMethod.patch
//        var paramDefault = ["request[title]": "\(request.title)",
//            "request[description]": "\(String(describing: request.description))",
//            "request[for_user_id]": "\(request.requestForId)", "request[assignee_id]": "\(request.assigneeId))",
//            "request[request_details_attributes]": "\(deviceString)"]
        var paramDefault: [String : Any] = ["request[title]": "\(request.title)",
            "request[description]": "\(String(describing: request.description))",
            "request[for_user_id]": request.requestForId, "request[assignee_id]": request.assigneeId]
        var param = [String: Any]()
        switch option {
        case .updateRequest:
            if let requestId = request.requestId {
                url = kYourRequestsURL + "/" + "\(requestId)"
                param = ["request[request_status_id]": request.requestStatusId]
            } else {
                return nil
            }
        case .addRequest:
            let deviceParam = buildMultiDevicesUpdate(device)
            param = ["request[request_details_attributes]": deviceParam]
            print(param)
            actionMethod = .post
            url = kYourRequestsURL
            
        }
        paramDefault.merge(with: param)
        if let paramResult = addRequestParams(dict: paramDefault) {
            return APIInputBase(urlString: url, param: paramResult.origin(), requestType: actionMethod)
        } else {
            return nil
        }
    }
    
    private func parserUpdateOrAddRequest(data: Any?, error: ErrorInfo?) -> Request? {
        guard let response = data, let error = error,
            let result = JsonParser.share.callToParser(option: .parserRawToObject, dataJson: response),
            let data = result.dataObject else {
                return nil
        }
        switch error.status {
        case StatusCode.actionChangeError.rawValue:
            return nil
        case StatusCode.deviceNotFound.rawValue:
            return nil
        default:
            break
        }
        let dataResult = Request(JSON: data)
        if let finalData = dataResult {
            return finalData
        } else {
            return nil
        }
    }
    
    private func createParamUpdateActionRequest(request: Request) -> APIInputBase? {
        guard let requestId = request.requestId else {
            return nil
        }
        let url = kYourRequestsURL + "/\(requestId)"
        if let paramResult = addRequestParams(dict: ["request[request_status_id]": request.requestStatusId]) {
            return APIInputBase(urlString: url, param: paramResult.origin(), requestType: .patch)
        } else {
            return nil
        }
    }
    
    private func createParamGetRequestById(requestId: Int) -> URLRequest? {
        let url = kYourRequestsURL + "/\(requestId)"
        if let urlRequest = asGetRequest(parameters: nil, url: url) {
            return urlRequest
        } else {
            return nil
        }
    }
    
}

extension RequestService {
    
    func buildMultiDevicesUpdate(_ devices: [DevicesForRequest]) -> [String] {
        var paramResult = [String]()
        for device in devices {
            let dictDevice = device.buildDeviceForUpdate()
            if let dictJson = dictDevice.convertDictToJson() {
                paramResult.append(dictJson.splitString("\n  "))
            }
        }
        return paramResult
    }
    
}
