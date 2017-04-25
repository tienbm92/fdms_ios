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
            let status = jsonResult["status"] as? StatusCode,
            let error = jsonResult["error"] as? Bool,
            let data = jsonResult["data"] as? [String: Any]
        else {
            return (.errorParseJSON, nil)
        }
        if status == .notFound, error == false {
            return (.errorNotFound, nil)
        } else {
            return (.normal, data)
        }
    }
    
    func parserRawToArray(JsonInput json: Any) -> (APIServiceError, [[String: Any]]?, Int?) {
        guard let jsonResult = json as? [String: Any],
            let status = jsonResult["status"] as? StatusCode,
            let error = jsonResult["error"] as? Bool,
            let totalPages = jsonResult["total_pages"] as? Int,
            let data = jsonResult["data"] as? [[String: Any]] else {
            return (.errorParseJSON, nil, nil)
        }
        if error {
            switch status {
            case .deleteOrUpdateError:
                return (.deleteOrUpdateError, nil, nil)
            case .deviceNotFound:
                return (.deviceNotFound, nil, nil)
            default:
                return (.errorSystem, nil, nil)
            }
        } else if status == .notFound {
            return (.errorNotFound, nil, nil)
        } else {
            return (.normal, data, totalPages)
        }
    }
    
    func parserRawNoTotalPages(JsonInput json: Any) -> (APIServiceError, [[String: Any]]?) {
        guard let jsonResult = json as? [String: Any],
            let status = jsonResult["status"] as? StatusCode,
            let error = jsonResult["error"] as? Bool,
            let data = jsonResult["data"] as? [[String: Any]] else {
                return (.errorParseJSON, nil)
        }
        if error {
            switch status {
            case .deleteOrUpdateError:
                return (.deleteOrUpdateError, nil)
            case .deviceNotFound:
                return (.deviceNotFound, nil)
            default:
                return (.errorSystem, nil)
            }
        } else if status == .notFound {
            return (.errorNotFound, nil)
        } else {
            return (.normal, data)
        }
    }
    
}
