//
//  BODNetworking.swift
//  bitreel
//
//  Created by ZCO Engineer on 07/04/16.
//  Copyright © 2016 MOPL. All rights reserved.
//

import UIKit

final class Networking {

    let session: URLSession
    let baseURL: URL

    init(baseURL: URL, session: URLSession = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
    }
}

extension Networking: NetworkingAPI {

    func makeWebserviceCall<T: JSONSerializable>(method: HTTPMethodType, with data: RequestProtocol, then callback: @escaping (Result<T>) -> Void) {

        //check internet reachability
        if ReachabilityManager.sharedInstance.isReachable() == false {
            callback(Result<T>.failure(MOError(.noReachability)))
            return
        }

        //show network indicator
        AppCommon.setNetWorkIndicatorVisible(true)

        //create url request
        guard let requestURL = URL(string: "\(baseURL)\(data.buildEndpoint())") else {
            callback(Result<T>.failure(MOError(.jsonParsingFailed)))
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue

        if method == .post {
            if let multiPartFields = data.getMultiPartDetails() {

                guard let requestData = createMultipartData(multiPartFields: multiPartFields, jsonBody: data.bodyJSON()) else {
                    AppCommon.setNetWorkIndicatorVisible(false)
                    callback(.failure(MOError(.jsonParsingFailed)))
                    return
                }
                request.httpBody = requestData

            } else {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data.bodyJSON(), options: JSONSerialization.WritingOptions.prettyPrinted)
                    request.httpBody = jsonData

                } catch {
                    AppCommon.setNetWorkIndicatorVisible(false)
                    callback(.failure(MOError(.jsonParsingFailed)))
                    return
                }
            }
            printToFile("Body Json: \(data.bodyJSON())")
        }

        //set header fields according to content type
        request.allHTTPHeaderFields = data.getRequestHeaders()

        printToFile("request: \(request))")

        sendRequest(request, completion: callback)
        //let responseHandler = createResponseHandler(with: callback)
        //Alamofire.request(request).responseJSON(completionHandler: responseHandler)
    }

    func sendRequest<T: JSONSerializable>(_ request: URLRequest, completion: @escaping (Result<T>) -> Void) {

        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in

            self.logResponse(data, response, error)

            if let errorResponse = self.checkForNetworkError(error, InResponse: response) {

                AppCommon.setNetWorkIndicatorVisible(false)
                completion(.failure(errorResponse))
                return
            }

            if let dataResp = data {
                do {
                    //try to convert JSON
                    let jsonResult: AnyObject = try JSONSerialization.jsonObject(with: dataResp, options:
                        JSONSerialization.ReadingOptions.mutableContainers) as AnyObject

                    // Attempt to serialize into a class.
                    do {
                        AppCommon.setNetWorkIndicatorVisible(false)
                        let serialized = try T.init(jsonValue: jsonResult)
                        completion(.success(serialized))
                        return
                    } catch let error {
                        AppCommon.setNetWorkIndicatorVisible(false)
                        if let err = error as? MOError {
                            completion(.failure(err))
                        } else {
                            completion(.failure(MOError(.jsonParsingFailed)))
                        }
                        printError("Serialization error: \(error)")

                    }
                    // success code
                } catch {
                    // failure code
                    AppCommon.setNetWorkIndicatorVisible(false)
                    completion(.failure(MOError(.jsonParsingFailed)))
                }
            } else {
                AppCommon.setNetWorkIndicatorVisible(false)
                completion(.failure(MOError(.webServiceResponseIsNil)))
            }
        })

        task.resume()
    }

    // MARK: - Private functions

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - multiPartFields: <#multiPartFields description#>
    ///   - jsonBody: <#jsonBody description#>
    /// - Returns: <#return value description#>
    func createMultipartData(multiPartFields: MultiPartFields, jsonBody: [String: Any]) -> Data? {

        let boundryString: String = ContentTypeConstants.boundryString
        let fileName = multiPartFields.fileName
        let name = multiPartFields.fileField
        var requestData: Data = Data()

        requestData.append("--\(boundryString)\r\n".toData())

        for (index, fileData) in multiPartFields.fileContent.enumerated() {
            requestData.append("Content-Disposition: form-data; name=\(name); filename=\(fileName)\r\n".toData())
            requestData.append("Content-Type: application/octet-stream\r\n\r\n".toData())
            requestData.append(fileData)
            if index < multiPartFields.fileContent.count {
                requestData.append("\r\n--\(boundryString)\r\n".toData())
            }
        }

        for (fieldName, value) in jsonBody {

            if fieldName == multiPartFields.jsonField {

                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted)
                    if let valueStr = String(data: jsonData, encoding: .utf8) {

                        requestData.append("\r\n--\(boundryString)\r\n".toData())
                        requestData.append("Content-Disposition: form-data; name=\(fieldName)\r\n".toData())
                        requestData.append("Content-Type: application/json\r\n\r\n".toData())
                        requestData.append(valueStr.toData())
                    }

                } catch {
                    return nil
                }

            } else {
                if let valueStr = value as? String {
                    requestData.append("\r\n--\(boundryString)\r\n".toData())
                    requestData.append("Content-Disposition: form-data; name=\(fieldName)\r\n".toData())
                    requestData.append("Content-Type: text/plain; charset=utf-8\r\n\r\n".toData())
                    requestData.append(valueStr.toData())
                }
            }
        }

        requestData.append("\r\n--\(boundryString)--\r\n".toData())

        return requestData
    }
    /// check for network errors
    ///
    /// - Parameters:
    ///   - error:
    ///   - response:
    /// - Returns: MOError if any error found
    func checkForNetworkError(_ error: Error?, InResponse response: URLResponse?) -> MOError? {
        if let err = error {
            // You can handle error response here
            AppCommon.setNetWorkIndicatorVisible(false)
            return MOError.errorFromErr(err)

        }

        if let httpResponse = response as? HTTPURLResponse {
            let status = httpResponse.statusCode

            // HTTP 2xx codes only, please!
            guard (200...299).contains(status) else {

                AppCommon.setNetWorkIndicatorVisible(false)
                return MOError.networkError(errorCode: status)
            }
        }
        return nil
    }

    /// log the responsees
    ///
    /// - Parameters:
    ///   - data:
    ///   - response:
    ///   - error:
    func logResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        #if DEBUG
            printDebug("httpResponse = \(String(describing: response))")
            printDebug("error = \(String(describing: error))")

            do {
                if let dataResp = data {
                    let jsonResult: AnyObject = try JSONSerialization.jsonObject(with: dataResp, options:
                        JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    printDebug("response=\(jsonResult)")
                }
            } catch {

            }
        #endif
        if Logging.isLogToFile {
            printToFile("httpResponse = \(String(describing: response))")
            printToFile("error = \(String(describing: error))")

            do {
                if let dataResp = data {
                    let jsonResult: AnyObject = try JSONSerialization.jsonObject(with: dataResp, options:
                        JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    printToFile("response=\(jsonResult)")
                }
            } catch(let err) {
                printToFile(err.localizedDescription)
            }
        }
    }
}
