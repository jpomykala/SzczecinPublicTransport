//
//  Vehicles.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 02/01/2022.
//  Copyright © 2022 Jakub Pomykała. All rights reserved.
//

import Foundation
import CoreLocation

class Vehicles: ObservableObject{
    
    var zditmService: ZditmService;
    @Published var vehicles: [VehiclePostion]
        
        init() {
            self.zditmService = ZditmService()
            self.vehicles = [
                VehiclePostion(
                    id: 343,
                    gmvid: 5433,
                    line: "53",
                    icon: "🚍",
                    from: "Małopanewska", to: "Legnicka",
                    delay: 5,
                    location: CLLocationCoordinate2D(latitude: CLLocationDegrees(53.4), longitude: CLLocationDegrees(14.5528)))
            ]
            
//            self.zditmService.fetchBuses(success: { (fetchedVehicles) in
//                       self.vehicles = fetchedVehicles
//                   }) { (error) in
//                       self.vehicles = []
//                   }
        }
        
}
