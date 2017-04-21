//
//  JsonParser.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/25/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class JsonParser {
    
    static let share: JsonParser = JsonParser()
    
    func parserRawToObject(JsonInput json: Any) -> (APIServiceError, [String: Any]?) {
        guard let jsonResult = json as? [String: Any],
            let status = jsonResult["status"] as? StatusCode.RawValue,
            let error = jsonResult["error"] as? Bool,
            let data = jsonResult["data"] as? [String: Any]
        else {
            return (.errorParseJSON, nil)
        }
        if status == StatusCode.notFound.rawValue, error == false {
            return (.errorNotFound, nil)
        } else {
            return (.normal, data)
        }
    }
    
    func parserRawToArray(JsonInput json: Any) -> (APIServiceError, [[String: Any]]?, Int?) {
        guard let jsonResult = json as? [String: Any],
            let status = jsonResult["status"] as? StatusCode.RawValue,
            let error = jsonResult["error"] as? Bool,
            let totalPages = jsonResult["total_pages"] as? Int,
            let data = jsonResult["data"] as? [[String: Any]] else {
            return (.errorParseJSON, nil, nil)
        }
        if error {
            switch status {
            case StatusCode.deleteOrUpdateError.rawValue:
                return (.deleteOrUpdateError, nil, nil)
            case StatusCode.deviceNotFound.rawValue:
                return (.deviceNotFound, nil, nil)
            default:
                return (.errorSystem, nil, nil)
            }
        } else if status == StatusCode.notFound.rawValue {
            return (.errorNotFound, nil, nil)
        } else {
            return (.normal, data, totalPages)
        }
    }
    
    func parserRawNoTotalPages(JsonInput json: Any) -> (APIServiceError, [[String: Any]]?) {
        guard let jsonResult = json as? [String: Any],
            let status = jsonResult["status"] as? StatusCode.RawValue,
            let error = jsonResult["error"] as? Bool,
            let data = jsonResult["data"] as? [[String: Any]] else {
                return (.errorParseJSON, nil)
        }
        if error {
            switch status {
            case StatusCode.deleteOrUpdateError.rawValue:
                return (.deleteOrUpdateError, nil)
            case StatusCode.deviceNotFound.rawValue:
                return (.deviceNotFound, nil)
            default:
                return (.errorSystem, nil)
            }
        } else if status == StatusCode.notFound.rawValue {
            return (.errorNotFound, nil)
        } else {
            return (.normal, data)
        }
    }
    
    func parserRawToUser(JsonInput json: Any) -> (APIServiceError, [String: Any]?, String?) {
        guard let jsonResult = json as? [String: Any],
            let status = jsonResult["status"] as? StatusCode.RawValue,
            let error = jsonResult["error"] as? Bool,
            let data = jsonResult["data"] as? [String: Any],
            let token = jsonResult["token"] as? String
        else {
            return (.errorParseJSON, nil, nil)
        }
        if status == StatusCode.notFound.rawValue, error == false {
            return (.errorNotFound, nil, nil)
        } else {
            return (.normal, data, token)
        }
    }
    
}
