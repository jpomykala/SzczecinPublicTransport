//
//  VehicleAnnotation.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/23/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//
import UIKit
import MapKit

final class VehicleAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(_ vehicle: VehiclePostion) {
        self.title = vehicle.line
        self.coordinate = vehicle.location!
    }
}
