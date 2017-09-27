//
//  CustomMarker.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/23/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class VehicleAnnotationView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? MarkerViewModel else { return }
            
            animatesWhenAdded = true
            glyphText = annotation.icon ?? ""
            clusteringIdentifier = nil
            markerTintColor = UIColor(hexString: "#64B5F6")
            let label = UILabel()
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.text = annotation.subtitle ?? ""
            detailCalloutAccessoryView = label
        }
    }
}
