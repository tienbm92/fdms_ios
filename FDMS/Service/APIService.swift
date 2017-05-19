//
//  APIService.swift
//  FDMS
//
//  Created by Bui Minh Tien on 5/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Alamofire
import Foundation

enum StatusCode: Int {
    case success = 200
    case notFound = 404
    case actionChangeError = 500
    case deviceNotFound = 401
    case invalidError = 400
    case pleaseLogin = 402
    case noPermission = 502
}

typealias NetworkServiceCompletion = (_ response: Any?, _ error: ErrorInfo?) -> Void

class APIService: NSObject {
    var request: Alamofire.Request?
    var timeout: Timer?
    var isCancel: Bool = false
    
    func doExecuteGetRequest(urlReuqest: URLRequest, completion: @escaping NetworkServiceCompletion) {
        self.startTimeoutTimer()
        Alamofire.request(urlReuqest).responseJSON(completionHandler: { [weak self] (response) in
            self?.processResponseRequest(response, completion: completion)
        })
    }
    
    func startTimeoutTimer() {
        self.stopTimeoutTimer()
        self.timeout = Timer.scheduledTimer(timeInterval: kTimeOut, target: self,
                                            selector: #selector(APIService.timeoutCallback),
                                            userInfo: nil, repeats: false)
    }
    
    func stopTimeoutTimer() {
        self.timeout?.invalidate()
        self.timeout = nil
    }
    
    func timeoutCallback() {
        self.cancel()
        self.stopTimeoutTimer()
    }
    
    func cancel() {
        self.isCancel = true
        self.request?.cancel()
    }
    
    fileprivate func processResponseRequest(_ response: DataResponse<Any>,
                                            completion: @escaping NetworkServiceCompletion) {
        self.stopTimeoutTimer()
        guard let jsonResult = response.result.value,
            let errorInfo = self.parserError(jsonResult) else {
            self.requestDidFail(completion)
            return
        }
        if let statusCode = response.response?.statusCode {
            self.onFinish(jsonResult, statusCode: statusCode, error: errorInfo, completion: completion)
        } else {
            self.onFinish(jsonResult, error: errorInfo, completion: completion)
        }
    }
    
    func requestDidFail(_ completion: @escaping NetworkServiceCompletion) {
        var error: ErrorInfo?
        error = ErrorInfo(status: 900, error: true, message: "")
        self.onFinish(nil, error: error, completion: completion)
    }
    
    func asGetRequest(parameters: [String: Any]?, url: String) -> URLRequest? {
        if let url = URL(string: url) {
            do {
                var urlrequest = URLRequest(url: url,
                                            cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                                            timeoutInterval: kTimeOut)
                urlrequest.allHTTPHeaderFields = kHeaders
                urlrequest.httpMethod = HTTPMethod.get.rawValue
                return try URLEncoding.queryString.encode(urlrequest, with: parameters)
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func asChangeRequest(parameters: [String: Any]?, url: String, method: HTTPMethod) -> URLRequest? {
        let paramString = parameters?.toHttpFormDataString()
        guard let url = URL(string: url),
            let paramData = paramString?.data(using: .utf8, allowLossyConversion: true), method != .get else {
            return nil
        }
        do {
            var urlRequest = URLRequest(url: url,
                                        cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                                        timeoutInterval: kTimeOut)
            urlRequest.allHTTPHeaderFields = kHeaders
            urlRequest.httpMethod = method.rawValue
            urlRequest.httpBody = paramData
            return try URLEncoding.queryString.encode(urlRequest, with: nil)
        } catch {
            return nil
        }
    }
    
    func parserError(_ response: Any?) -> ErrorInfo? {
        if let responseDict = response as? [String: Any], let status = responseDict["status"] as? Int,
           let error = responseDict["error"] as? Bool, let message = responseDict["message"] as? String {
            return ErrorInfo(status: status, error: error, message: message)
        }
        return nil
    }
   
    func onFinish(_ response: Any?, statusCode: Int = 0, error: ErrorInfo?, completion: NetworkServiceCompletion?) {
        DispatchQueue.main.async(execute: {
            completion?(response, error)
        })
    }
    
    func addRequestParams(dict: [String: String]) -> RequestParams? {
        let param = RequestParams()
        if dict.isEmpty {
            return nil
        } else {
            for (key, value) in dict {
                param.setValue(value, forKey: key)
            }
            return param
        }
    }
    
}
