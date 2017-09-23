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
    let color: UIColor
    let subtitle: String?
    let type: MarkerType
    
    init(title: String,
         coordinate: CLLocationCoordinate2D,
         color: UIColor,
         subtitle: String,
         type: MarkerType) {
        self.title = title
        self.coordinate = coordinate
        self.color = color
        self.subtitle = subtitle
        self.type = type
    }
}
