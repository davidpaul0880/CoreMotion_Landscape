import Foundation

func parseDictionaryToModel<T: JSONSerializable>(_ dictionary: [String: Any], parseCompletion: (Result<T>) -> Void) {

    return toModel(dictionary, parseCompletion: parseCompletion)

}

func toModel<T: JSONSerializable>(_ object: Any, parseCompletion: (Result<T>) -> Void) {
    do {
        let serialized = try T.init(jsonValue: object)
        parseCompletion(.success(serialized))
    } catch let error {
        printError("Serialization error: \(error)")
        parseCompletion(.failure(MOError(.jsonParsingFailed)))
    }
}
