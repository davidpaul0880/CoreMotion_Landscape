//
//  NetworkConfig.swift
//  sample
//
//  Created by ZCo Engg Dept on 25/08/16.
//  Copyright © 2016 zco. All rights reserved.
//

import Foundation

//http://stackoverflow.com/questions/27021var/nsurlsession-concurrent-requests-with-alamofire

enum Endpoint: String {

    case login              = "Account/Login"

    static func setSessionKey(_ token: String?) {
        UserDefaults.standard.set(token, forKey: "authToken")
        UserDefaults.standard.synchronize()
    }
    static func getSessionKey() -> String? {
        return UserDefaults.standard.object(forKey: "authToken") as? String
    }

    static func getAPIKey() -> String? {
        return Utils.getVendorID()
    }
}

class NetworkConfig {

    static let kErrorSessionExpired = 1000
    static let kErrorUnknown = 2037

    class func hubURL() -> String {
        let dictionary = Bundle.main.infoDictionary!
        if let isProductionServer = dictionary["IsProductionServer"] as? Bool, isProductionServer == true {
            return "http://5.24.86.130:8027"
        } else {
            return "http://10.1.1.15:8373"
        }

    }
    class func baseURL() -> String {

        let dictionary = Bundle.main.infoDictionary!
        if let isProductionServer = dictionary["IsProductionServer"] as? Bool, isProductionServer == true {
            return "http://23.3.151.19:8066/api/"
        } else {
            return "http://1.1.1.18:8092/api/"
        }
    }

    static var networkingAPI: NetworkingAPI {
        return Networking(baseURL: URL(string: NetworkConfig.baseURL())!, session: URLSession(configuration: URLSessionConfiguration.default))
    }

}

struct RequestData: RequestProtocol {

    var endpoint: Endpoint
    var parameters: [String: Any]?
    var body: [String: Any]
    var endpointDetails: String
    var multiPartDetails: MultiPartFields?
    var contentType: HTTPContentType = .json

    func bodyJSON() -> [String: Any] {
        return body
    }

    func getRequestHeaders() -> [String: String] {

        var requestHeaders: [String: String] = [String: String]()
        switch contentType {
        case .json:
            requestHeaders["Content-Type"] = contentType.toString()
        case .urlEncoded, .multipart:
            requestHeaders["Content-Type"] = contentType.toString()
        }

        if let token = getSessionToken() {
            printDebug("AccessToken: \(token)")
            requestHeaders["Authorization"] = "Bearer \(token)"
        } else {
            if !isAuth() {
                // Fail
            }
        }
        if let apikey = getAPIKey() {
            printDebug("apikey: \(apikey)")
            requestHeaders["DeviceID"] = apikey
        }

        return requestHeaders
    }

    init(endpoint: Endpoint, endpointDetails: String = "", parameters: [String: Any]? = nil, body: [String: Any]? = nil) {
        self.endpoint = endpoint
        self.endpointDetails = endpointDetails
        self.parameters = parameters
        self.body = body ?? [String: Any]()
    }
    init(endpoint: Endpoint, endpointDetails: String = "", parameters: [String: Any]? = nil, body: [String: Any]? = nil, multiPartDetails: MultiPartFields? = nil) {
        self.endpoint = endpoint
        self.endpointDetails = endpointDetails
        self.parameters = parameters
        self.body = body ?? [String: Any]()
        self.multiPartDetails = multiPartDetails
        if multiPartDetails != nil {
            self.contentType = .multipart
        }
    }

    func buildParameters() -> String {
        var queryString = ""
        guard let keys = parameters?["params"] as? [Int] else {
            return queryString
        }
        for key in keys {
            queryString += "/"
            queryString += "\(key)"
        }
        return queryString
    }

    func buildEndpoint() -> String {
        return "\(endpoint.rawValue)\(buildParameters())\(endpointDetails)"
    }
    func isAuth() -> Bool {
        if Endpoint.login == endpoint {
            return true
        }
        return false
    }
    func getAPIKey() -> String? {
        return Endpoint.getAPIKey()
    }
    func getSessionToken() -> String? {
        return Endpoint.getSessionKey()
    }

    func getMultiPartDetails() -> MultiPartFields? {
        return multiPartDetails
    }
}
