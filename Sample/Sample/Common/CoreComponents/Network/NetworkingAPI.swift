//
//  NetworkingAPI.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 07/04/16.
//  Copyright © 2017 JPulikkottil All rights reserved.
//

import Foundation

struct ContentTypeConstants {

    static let boundryString: String = "----WebKitFormBoundaryypF2fwBcAMX1vEFe"
    static let jSON: String = "application/json"
    static let uRLEncoded: String = "application/x-www-form-urlencoded"
    static var multiPart: String {
        return "multipart/form-data; boundary=\(boundryString)"
    }
}

struct MultiPartFields {
    var fileName: String
    var fileField: String
    var fileContent: [Data]
    var jsonField: String?

    init(fileName: String, fileField: String, fileContent: [Data], jsonField: String?) {
        self.fileName = fileName
        self.fileField = fileField
        self.fileContent = fileContent
        self.jsonField = jsonField
    }
}

typealias NetworkCompletion = (Result<JSONSerializable>) -> Void

protocol RequestProtocol {
    func buildEndpoint() -> String
    func bodyJSON() -> [String: Any]
    func isAuth() -> Bool
    func getAPIKey() -> String?
    func getSessionToken() -> String?
    func getMultiPartDetails() -> MultiPartFields?
    func getRequestHeaders() -> [String: String]
}

enum HTTPMethodType: String {
    case post = "POST"
    case get = "GET"
}

enum HTTPContentType: String {
    case json
    case urlEncoded
    case multipart

    func toString() -> String {
        switch self {
        case .json:
            return ContentTypeConstants.jSON
        case .urlEncoded:
            return ContentTypeConstants.uRLEncoded
        case .multipart:
            return ContentTypeConstants.multiPart
        }
    }
}

protocol NetworkingAPI {

    /// make web service call using given http method and data
    ///
    /// - Parameters:
    ///   - method: get or post
    ///   - data: json body
    ///   - callback: 
    func makeWebserviceCall<T: JSONSerializable>(method: HTTPMethodType, with data: RequestProtocol, then callback: @escaping (Result<T>) -> Void)

}
