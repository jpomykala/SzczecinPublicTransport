//
//  VehicleAnnotation.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/23/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//
import UIKit
import MapKit

final class MarkerViewModel: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?
    let icon: String!
    
    init(_ vehicle: VehiclePostion) {
        self.title = "\(vehicle.icon ?? "") Linia \(vehicle.line ?? "nieznana linia")"
        
        self.coordinate = vehicle.location!
        self.icon = vehicle.icon ?? ""
        
        var subtitle = ""

        if vehicle.delay == nil {
            subtitle = "nieznany"
        }
        let delay = vehicle.delay!
        if delay < 0 {
            subtitle =  "🕑 Opóźnienie \(abs(delay)) min"
        } else if delay > 0 {
            subtitle =  "🕑 \(delay) min szybciej"
        } else if delay == 0 {
            subtitle =  "🕑 Zgodnie z rozkładem"
        }
        self.subtitle = subtitle
    }
    

}
