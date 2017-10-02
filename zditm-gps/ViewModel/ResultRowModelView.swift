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
    let isSummary: Bool!
    
    init(_ vehicle: VehiclePostion, isSummary: Bool) {
        self.vehicle = vehicle
        self.isSummary = isSummary
    }
    
    var icon: String {
       return vehicle.icon ?? ""
    }
    
    var id : Int {
        return vehicle.id!
    }
    
    var line: String {
        return vehicle.line ?? ""
    }
    
    var title: String {
        return "\(vehicle.line ?? "??")"
    }
    
    var delay: String {
        
       guard let delay = vehicle.delay else {
            return "??"
        }
        
        if delay == 0 {
            return "👌"
        }
        
        return String(format: "%02d", abs(delay))
    }
    
    var delayText: String {
        
        guard let delay = vehicle.delay else {
            return "??"
        }
        
        if delay < 0 {
            return "opóźnienia"
        }
        
        if delay > 0 {
            return "szybciej"
        }
        return "o czasie"
    }
    
    var minutes: String {
        guard let delay = vehicle.delay else {
            return ""
        }
        if delay != 0 {
            return "min"
        }
        
        return ""
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
