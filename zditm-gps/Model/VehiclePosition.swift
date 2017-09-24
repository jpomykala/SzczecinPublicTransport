//
//  VehiclePosition.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/22/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import MapKit

struct VehiclePostion: Decodable {
    var id: Int?
    var line: String?
    var type: VehicleType?
    var from: String?
    var to: String?
    var speed: Int?
    var delay: Int?
    var location: CLLocationCoordinate2D?
    
    enum CodingKeys: String, CodingKey {
        case id
        case line = "linia"
        case type = "typlinii"
        case from = "z"
        case to = "do"
        case speed = "predkosc"
        case delay = "punktualnosc2"
        case lat = "lat"
        case lon = "lon"
    }
}

extension VehiclePostion {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        id = Int(idString)
        line = try container.decode(String.self, forKey: .line)
        let typeString = try container.decode(String.self, forKey: .type)
        type = .OTHER
        if typeString.contains("a") {
            type = .BUS
        }
        
        if typeString.contains("t"){
            type = .TRAM
        }
        from = try container.decode(String.self, forKey: .from)
        to = try container.decode(String.self, forKey: .to)
        
//        let speedString = try container.decode(String.self, forKey: .speed)
        speed = 0
        
        var delayString = try container.decode(String.self, forKey: .delay)
        delayString = delayString.replacingOccurrences(of: "&minus;", with: "-")
        if let delayInt = Int(delayString) {
            delay = delayInt
        }
        
        let latitudeString = try container.decode(String.self, forKey: .lat)
        let longitudeString = try container.decode(String.self, forKey: .lon)
        if let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
            let latitudeDegrees = CLLocationDegrees(latitude)
            let longitudeDegrees = CLLocationDegrees(longitude)
            location = CLLocationCoordinate2D(latitude: latitudeDegrees, longitude: longitudeDegrees)
        }
    }
}

