// To parse the JSON, add this file to your project and do:
//
//   let alert = Alert.from(json: jsonString)!

import Foundation

typealias Alert = OtherAlert

class OtherAlert: Codable {
    let od: String
    let otherDo: JSONNull
    let opis: String
}

// Serialization extensions

extension OtherAlert {
    static func from(json: String, using encoding: String.Encoding = .utf8) -> OtherAlert? {
        guard let data = json.data(using: encoding) else { return nil }
        return OtherAlert.from(data: data)
    }
    
    static func from(data: Data) -> OtherAlert? {
        let decoder = JSONDecoder()
        return try? decoder.decode(OtherAlert.self, from: data)
    }
    
    var jsonData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension OtherAlert {
    enum CodingKeys: String, CodingKey {
        case od
        case otherDo = "do"
        case opis
    }
}

// Helpers

class JSONNull: Codable {
    public init() {
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

