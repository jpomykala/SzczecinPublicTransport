//
//  VehicleAnnotation.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/23/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//
import UIKit
import MapKit

final class CustomAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?
    let type: MarkerType
    let delay: Int
    
    init(title: String,
         coordinate: CLLocationCoordinate2D,
         type: MarkerType,
         delay: Int) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = "Opóźnienie \(delay)"
        self.type = type
        self.delay = delay
    }
}
