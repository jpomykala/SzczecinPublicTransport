//
//  LineType.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/23/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation

enum VehicleType {
    case BUS
    case TRAM
    case OTHER
    
    init(value: String?){
        guard let value = value else {
            self = .OTHER
            return
        }
        
        
        if value.contains("a") {
            self = .BUS
        }
        
        if value.contains("t"){
            self = .TRAM
        }
        
        self = .OTHER
    }
}
