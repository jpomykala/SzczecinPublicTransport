//
//  StopDepartureInfo.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 10/1/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//
import Foundation

typealias StopDepartureInfo = OtherStopDepartureInfo

struct OtherStopDepartureInfo: Codable {
    let kurs: String
    let tekst: String
}

// Serialization extensions

extension OtherStopDepartureInfo {
    static func from(json: String, using encoding: String.Encoding = .utf8) -> OtherStopDepartureInfo? {
        guard let data = json.data(using: encoding) else { return nil }
        return OtherStopDepartureInfo.from(data: data)
    }
    
    static func from(data: Data) -> OtherStopDepartureInfo? {
        let decoder = JSONDecoder()
        return try? decoder.decode(OtherStopDepartureInfo.self, from: data)
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

extension OtherStopDepartureInfo {
    enum CodingKeys: String, CodingKey {
        case kurs
        case tekst
    }
}


