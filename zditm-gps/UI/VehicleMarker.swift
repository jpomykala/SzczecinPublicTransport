//
//  VehicleView.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/23/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class VehicleMarker: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? VehicleAnnotation else { return }
            clusteringIdentifier = annotation.title
            markerTintColor = UIColor(hexString: "#64B5F6")
            glyphText = "🚍"
            animatesWhenAdded = true
        }
    }
}
