//
//  JsonParser.swift
//  FDMS
//
//  Created by Bui Minh Tien on 4/25/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

enum APIServiceError: Error {
    case errorParseJSON
    case errorNotFound
    case deleteOrUpdateError
    case deviceNotFound
    case errorSystem
    case errorLogin
    case normal
}

enum OptionParserRaw {
    case parserRawToObject
    case parserRawToArray
    case parserRawNoTotalPages
    case parserRawToUser
}

enum OptionArrayOrObject {
    case array
    case object
}

class JsonParser {
    
    static let share: JsonParser = JsonParser()
    
    func callToParser(option: OptionParserRaw, dataJson: Any) -> ParserResult? {
        var result: ParserResult?
        switch option {
        case .parserRawNoTotalPages:
            result = self.parserRawNoTotalPages(JsonInput: dataJson)
        case .parserRawToArray:
            result = self.parserRawToArray(JsonInput: dataJson)
        case .parserRawToObject:
            result = self.parserRawToObject(JsonInput: dataJson)
        case .parserRawToUser:
            result = self.parserRawToUser(JsonInput: dataJson)
        }
        if let result = result {
            return self.handleResult(result: result)
        } else {
            return nil
        }
    }
    
    private func parserRawToObject(JsonInput json: Any) -> ParserResult? {
        var result = ParserResult()
        guard let jsonResult = json as? [String: Any],
            let data = jsonResult["data"] as? [String: Any]
        else {
            return result
        }
        if data.isEmpty {
            result.status = .errorNotFound
        } else {
            result.status = .normal
            result.dataObject = data
        }
        return result
    }
    
    private func parserRawToArray(JsonInput json: Any) -> ParserResult? {
        var result = ParserResult()
        guard let jsonResult = json as? [String: Any],
            let totalPages = jsonResult["total_pages"] as? Int,
            let data = jsonResult["data"] as? [[String: Any]] else {
            return result
        }
        if data.isEmpty {
            result.status = .errorNotFound
        } else {
            result.status = .normal
            result.dataArray = data
            result.totalPages = totalPages
        }
        return result
    }
    
    private func parserRawNoTotalPages(JsonInput json: Any) -> ParserResult? {
        var result = ParserResult()
        guard let jsonResult = json as? [String: Any],
            let data = jsonResult["data"] as? [[String: Any]] else {
            return result
        }
        if data.isEmpty {
            result.status = .errorNotFound
        } else {
            result.status = .normal
            result.dataArray = data
        }
        return result
    }
    
    private func parserRawToUser(JsonInput json: Any) -> ParserResult? {
        var result = ParserResult()
        guard let jsonResult = json as? [String: Any],
            let data = jsonResult["data"] as? [String: Any],
            let token = jsonResult["token"] as? String
        else {
            return result
        }
        if data.isEmpty {
            result.status = .errorNotFound
        } else {
            result.status = .normal
            result.dataObject = data
            result.token = token
        }
        return result
    }
    
    private func handleResult(result: ParserResult) -> ParserResult {
        var returnValue = ParserResult(status: result.status, dataObject: nil,
                                       dataArray: nil, totalPages: nil, token: nil)
        if result.token != nil {
            returnValue.dataObject = result.dataObject
            returnValue.token = result.token
        } else if result.totalPages != nil {
            returnValue.dataArray = result.dataArray
            returnValue.totalPages = result.totalPages
        } else if result.dataArray != nil {
            returnValue.dataArray = result.dataArray
        } else if result.dataObject != nil {
            returnValue.dataObject = result.dataObject
        }
        return returnValue
    }
}
