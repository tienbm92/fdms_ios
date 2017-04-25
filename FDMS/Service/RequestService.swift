//
//  RequestService.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/21/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Alamofire
import Foundation

enum RequestResult {
    case success([Request])
    case failure(Error)
}

enum ManagerValueResult {
    case success([ManagerValue])
    case failure(Error)
}

enum StatusCode: Int {
    case success = 200
    case notFound = 404
    case deleteOrUpdateError = 500
    case deviceNotFound = 401
}

enum APIServiceError: Error {
    case errorParseJSON
    case errorNotFound
    case deleteOrUpdateError
    case deviceNotFound
    case errorSystem
    case normal
}

class RequestService {
    
    static let share: RequestService = RequestService()
    fileprivate lazy var totalPages: Int = 0
    
    func getTotalPages() -> Int {
        return totalPages
    }
    
    func getListRequest(UserID uid: Int, RequestStatusId statusId: Int?, RelativeID relativeID: Int?,
                        Page page: Page, completion: @escaping (RequestResult) -> Void) {
        var infoDict = [String: String]()
        if let statusId = statusId, let relativeID = relativeID {
            infoDict = ["user_id": "\(uid)", "request_status_id": "\(statusId)", "relative_id": "\(relativeID)",
                "per_page": "\(page.perPage)", "page": "\(page.page)"]
        } else {
            infoDict = ["user_id": "\(uid)", "per_page": "\(page.perPage)", "page": "\(page.page)"]
        }
        Alamofire.request(kRequestsURL, method: .get, parameters: infoDict,
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
                var listRequests = [Request]()
                for requests in data {
                    let request = Request(JSON: requests)
                    if let request = request {
                        listRequests.append(request)
                    } else {
                        completion(.failure(APIServiceError.errorParseJSON))
                        return
                    }
                }
                if listRequests.isEmpty {
                    completion(.failure(APIServiceError.errorNotFound))
                } else {
                    completion(.success(listRequests))
                }
            } else {
                completion(.failure(APIServiceError.errorSystem))
            }
        }
    }
    
}
