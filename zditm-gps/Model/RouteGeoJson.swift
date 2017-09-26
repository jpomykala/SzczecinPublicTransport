// To parse the JSON, add this file to your project and do:
//
//   let routeGeoJson = RouteGeoJson.from(json: jsonString)!

import Foundation

typealias RouteGeoJson = OtherRouteGeoJson

class OtherRouteGeoJson: Codable {
    let features: [Feature]
    let type: String
}

class Feature: Codable {
    let geometry: Geometry
    let type: String
}

class Geometry: Codable {
    let coordinates: [[Double]]
    let type: String
}

// Serialization extensions

extension OtherRouteGeoJson {
    static func from(json json: String, using encoding: String.Encoding = .utf8) -> OtherRouteGeoJson? {
        guard let data = json.data(using: encoding) else { return nil }
        return OtherRouteGeoJson.from(data: data)
    }
    
    static func from(data data: Data) -> OtherRouteGeoJson? {
        let decoder = JSONDecoder()
        return try? decoder.decode(OtherRouteGeoJson.self, from: data)
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

extension Feature {
    enum CodingKeys: String, CodingKey {
        case geometry
        case type
    }
}

extension Geometry {
    enum CodingKeys: String, CodingKey {
        case coordinates
        case type
    }
}

extension OtherRouteGeoJson {
    enum CodingKeys: String, CodingKey {
        case features
        case type
    }
}


