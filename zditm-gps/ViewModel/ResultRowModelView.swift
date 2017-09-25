//
//  ResultRowModelView.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/25/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation

class ResultRowModelView {
    
    private let vehicle: VehiclePostion!
    
    init(_ vehicle: VehiclePostion) {
        self.vehicle = vehicle
    }
    
    var icon: String {
       return vehicle.icon ?? ""
    }
    
    var title: String {
        return "\(vehicle.icon ?? "") Linia \(vehicle.line ?? "nieznana linia")"
    }
    
    var delay: String {
        
       guard let delay = vehicle.delay else {
            return "nieznane"
        }
        
        if delay < 0 {
            return "🕑 Opóźnienie \(abs(delay)) min"
        }
        
        if delay > 0 {
            return "🕑 \(delay) min szybciej"
        }
        return "🕑 Zgodnie z rozkładem"
    }
    
    var from: String {
        guard let from = vehicle.from else {
            return "nieznane"
        }
        
        if from.isEmpty {
            return "nieznane"
        }
        
        return from
    }
    
    var to: String {
        guard let to = vehicle.to else {
            return "nieznane"
        }
        
        if to.isEmpty {
            return "nieznane"
        }
        
        return to
    }
    
}
