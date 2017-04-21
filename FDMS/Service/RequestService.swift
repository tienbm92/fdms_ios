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
    
    func getListRequests(UserID uid: Int, RequestStatusId statusId: Int?, RelativeID relativeID: Int?,
                         Page page: Page, completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserGetRequests
        if let urlRequest = self.createUrlRequest(UserID: uid, RequestStatusId: statusId,
                                                  RelativeID: relativeID, Page: page) {
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
    
    func updateOrAddRequest(OptionActionRequest option: optionActionRequest, RequestUpdate request: Request,
                            userId: Int, completion: @escaping (CompletionResult) -> Void) {
        self.optionParser = .parserUpdateOrAddRequest
        if let urlRequest = createParamUpdateOrAddRequest(option: option, request: request, userId: userId) {
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
        default:
            return nil
        }
    }
    
    private func createUrlRequest(UserID uid: Int, RequestStatusId statusId: Int?, RelativeID relativeID: Int?,
                                  Page page: Page) -> URLRequest? {
        var paramDefault = ["user_id": "\(uid)", "per_page": "\(page.perPage)", "page": "\(page.page)"]
        var param = [String: String]()
        if let statusId = statusId, let relativeID = relativeID {
            param = ["request_status_id": "\(statusId)", "relative_id": "\(relativeID)"]
        }
        if let statusId = statusId {
            param = ["request_status_id": "\(statusId)"]
        }
        if let relativeID = relativeID {
            param = ["relative_id": "\(relativeID)"]
        }
        paramDefault.merge(with: param)
        if let paramResult = addRequestParams(dict: paramDefault),
            let urlRequest = asGetRequest(parameters: paramResult.origin(), url: kRequestsURL) {
            return urlRequest
        }
        return nil
    }
    
    private func parserGetRequests(data: Any?, error: ErrorInfo?) -> [Request]? {
        guard let responseResult = data, let error = error,
            let result = JsonParser.share.parserRawToArray(JsonInput: responseResult),
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
    
    private func createParamUpdateOrAddRequest(option: optionActionRequest,
                                               request: Request, userId: Int) -> URLRequest? {
        var url = ""
        var actionMethod = HTTPMethod.patch
        guard let title = request.title, let status = request.requestStatus, let requestId = request.requestId else {
            return nil
        }
        var paramDefault = ["request[title]": "\(title)", "request[description]": "\(request.description)",
            "request[for_user_id]": "\(userId)", "request[assignee_id]": "\(request.assignee)",
            "request[request_details_attributes]": "\(request.devices)"]
        var param = [String: String]()
        switch option {
        case .updateRequest:
            url = kRequestsURL + "/" + "\(requestId)"
            param = ["request[request_status_id]": "\(status)"]
        case .addRequest:
            actionMethod = .post
            url = kRequestsURL
        }
        paramDefault.merge(with: param)
        if let paramResult = addRequestParams(dict: paramDefault),
           let urlRequest = asChangeRequest(parameters: paramResult.origin(), url: url, method: actionMethod) {
            return urlRequest
        }
        return nil
    }
    
    private func parserUpdateOrAddRequest(data: Any?, error: ErrorInfo?) -> Request? {
        guard let response = data, let error = error,
            let result = JsonParser.share.parserRawToObject(JsonInput: response),
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
    
}
