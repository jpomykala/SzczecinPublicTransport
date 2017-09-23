//
//  VehicleStop.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/23/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import MapKit

struct VehicleStop: Decodable, Equatable {
    static func ==(lhs: VehicleStop, rhs: VehicleStop) -> Bool {
        return lhs.id! == rhs.id!
    }
    
    
    var id: Int?
    var location: CLLocationCoordinate2D?
    var name: String?
    var groupId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case lat = "szerokoscgeo"
        case lon = "dlugoscgeo"
        case name = "nazwa"
        case groupId = "nrzespolu"
    }
}

extension VehicleStop {
    init(from decoder: Decoder) throws {
        
        do {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        groupId = try container.decode(Int.self, forKey: .groupId)
        let latitude = try container.decode(Float.self, forKey: .lat)
        let longitude = try container.decode(Float.self, forKey: .lon)
        let latitudeDegrees = CLLocationDegrees(latitude)
        let longitudeDegrees = CLLocationDegrees(longitude)
        location = CLLocationCoordinate2D(latitude: latitudeDegrees, longitude: longitudeDegrees)
        } catch {
            print("eeerror")
        }
        
    }
}
