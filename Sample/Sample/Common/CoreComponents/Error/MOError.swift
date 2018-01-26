import UIKit
import Foundation

enum NetworkError: Int {

    case webServiceResponseIsNil = 1
    case jsonParsingFailed
    case invalidJSONDataStructure
    case keyMissing
    case noReachability
}

enum PermissionError: Int {

    case webServiceResponseIsNil = 50
    case jsonParsingFailed
    case invalidJSONDataStructure
    case keyMissing
}

struct MOError: Error {

    enum ErrorKind {
        case definedErrors
        case otherErrors
        case customErrors
    }

    var code: Int
    var kind: ErrorKind
    internal var message: String
    var userInfo: Any?

    private init(errorCode: Int, msg: String, errorKind: ErrorKind) {
        code = errorCode
        message = msg
        kind = errorKind
    }

    private init(errorCode: Int, msg: String, errorKind: ErrorKind, jsonValue: Any? = nil) {
        code = errorCode
        message = msg
        kind = errorKind
    }

    init(errorCode: Int = 0, msg: String) {

        // A defined error code value was passed in custom error, hence block execution
        //precondition((definedErrors(rawValue: errorCode) == nil), "A defined error code value was passed in custom error")
        code = errorCode
        message = msg
        kind = .customErrors
    }

    init(_ error: NetworkError) {
        code = error.rawValue
        message = ""
        kind = .definedErrors
    }

    init(_ error: NetworkError, msg: String) {
        code = error.rawValue
        message = msg
        kind = .definedErrors
    }

    static func errorFromErr(_ err: Error, kind: ErrorKind = .otherErrors) -> MOError {
        return MOError(errorCode: NetworkError.webServiceResponseIsNil.rawValue, msg: err.localizedDescription, errorKind: kind)
    }

    static func networkError(errorCode: Int) -> MOError {

        let message: String
        switch errorCode {
        case 300...399:
            message = "error.server.unknown".localized()//"Unexpected redirect from server."
        case 401:
            message = "error.server.unknown".localized()//"Unauthorized."
        case 400...499:
            message = "error.server.unknown".localized()//"Bad request."
        case 500...599:
            message = "error.server.unknown".localized()//"Server error."
        default:
            message = "error.server.unknown".localized()//"Unexpected status code \(errorCode)."
        }

        return MOError(errorCode: errorCode, msg: message, errorKind: .otherErrors)
    }
}

extension MOError: LocalizedError {
    public var errorDescription: String {
        switch kind {
        case .otherErrors:
            return message
        case .customErrors:
            return message
        case .definedErrors:
            if let errCode = NetworkError(rawValue: code) {
                switch errCode {
                case .webServiceResponseIsNil:
                    return "error.server.unknown".localized()
                case .jsonParsingFailed:
                    return "error.server.unknown".localized()//"JSON parsing failed."
                case .invalidJSONDataStructure:
                    return "error.server.unknown".localized()//"JSON Data structure is invalid"
                case .keyMissing:
                    return "Required key \(message) missing"//"error.server.unknown".localized()//
                case .noReachability:
                    return "alert.no.connectivity".localized()
                }
            } else {
                return message
            }
        }
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        return nil
    }

    /// A localized message describing how one might recover from the failure.
    public var recoverySuggestion: String? {
        return nil
    }

    /// A localized message providing "help" text if the user requests help.
    public var helpAnchor: String? {
        return nil
    }
}
