import Foundation

protocol JSONSerializable {
    init(jsonValue: Any) throws
}

protocol JSONDictionarySerializable: JSONSerializable {

    init(json: [String: Any]) throws
}

protocol JSONArraySerializable: JSONSerializable {
    init(json: [Any]) throws
}

protocol JSONDictionaryDeserializable {
    /**
     Creates a dictionary representation of this class.
     */
    func toJSON() -> [String: Any]
}
protocol JSONDeserializable {
    /**
     Creates a dictionary representation of this class.
     */
    func toJSON() -> Any
}
extension JSONSerializable where Self: JSONDictionarySerializable {
    init(jsonValue: Any) throws {
        guard let dictionary = jsonValue as? [String: AnyObject] else {
            throw MOError(.invalidJSONDataStructure)
        }
        //check for Server defined errors
        if let errorCode = (dictionary["ErrorCode"] as? Int), errorCode > 0 {

            if let errMsg = dictionary["ErrorMessage"] as? String {
                throw MOError(errorCode: errorCode, msg: errMsg.localized())
            } else {
                throw MOError(errorCode: errorCode, msg: "Unexpected error code \(errorCode).")//ToDo: localize it
            }
        }

        try self.init(json: dictionary)
    }
}

extension JSONSerializable where Self: JSONArraySerializable {
    init(jsonValue: Any) throws {
        guard let array = jsonValue as? [AnyObject] else {
            throw MOError(.invalidJSONDataStructure)
        }
        try self.init(json: array)
    }
}

struct JSONArray<T: JSONSerializable>: JSONArraySerializable {
    let values: [T]

    init(json: [Any]) throws {
        self.values = try json.map {
            try T(jsonValue: $0)
        }
    }
}
