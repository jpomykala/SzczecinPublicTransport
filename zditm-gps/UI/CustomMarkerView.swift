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
            
            animatesWhenAdded = false
            
            glyphText = "?"
           
            if annotation.type == .BUS {
                glyphText = "🚍"
            }
            
            if annotation.type == .TRAM {
                glyphText = "🚋"
            }
            
            if annotation.type == .BUS || annotation.type == .TRAM {
                clusteringIdentifier = nil
                markerTintColor = UIColor(hexString: "#64B5F6")
                let label = UILabel()
                label.numberOfLines = 0
                label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                
                label.text = "Opóźnienie \(annotation.delay)min"
                if annotation.delay == 0{
                    label.text = "Bez opóźnienia"
                }
                
                detailCalloutAccessoryView = label
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                glyphText = "P"
                markerTintColor = UIColor(hexString: "#FF7043")
                clusteringIdentifier = nil
            }
            
        }
    }
}
