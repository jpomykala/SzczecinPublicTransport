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

class CustomMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? CustomAnnotation else { return }
           
            markerTintColor = annotation.color
            glyphText = annotation.title
            animatesWhenAdded = false
            
            
            if annotation.type == .BUS {
                titleVisibility = .visible
                 clusteringIdentifier = "A"
            } else {
                 clusteringIdentifier = "P"
            }
            
            
        }
    }
}
