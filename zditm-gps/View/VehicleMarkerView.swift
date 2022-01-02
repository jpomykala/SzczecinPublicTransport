//
//  CustomMarker.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/23/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct VehicleMarkerView: View {
    
    @State private var isOpen = false
    
    let vehicle: VehiclePostion
    var line: String
    let width = 0.8;
    let fontSize = 12.0
    
    init(vehicle: VehiclePostion){
        self.vehicle = vehicle;
        self.line = "Linia \(vehicle.line ?? "?")"
    }

    var body: some View {
        VStack(alignment: .center, spacing: 4){
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 100/255, green: 181/255, blue: 246/255), .blue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            Text(vehicle.icon!)
                .font(.system(size: 12))
                .padding(8)
               
        }.clipShape(Circle())
            .overlay(
                   Circle()
                       .stroke(Color.white, lineWidth: 2)
               )
            .shadow(radius: 10)
            
            ZStack{
                        ZStack{
                            Text(line).font(.system(size: fontSize, weight: .bold)).offset(x:  width, y:  width)
                            Text(line).font(.system(size: fontSize, weight: .bold)).offset(x: -width, y: -width)
                            Text(line).font(.system(size: fontSize, weight: .bold)).offset(x: -width, y:  width)
                            Text(line).font(.system(size: fontSize, weight: .bold)).offset(x:  width, y: -width)
                        }
                        .foregroundColor(Color.init(red: 28/255, green: 28/255, blue: 28/255))
                Text(line).foregroundColor(.white).font(.system(size: fontSize, weight: .bold))
                    }
            
                
            
    }
       
    }
        
}

struct VehicleMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleMarkerView(vehicle: VehiclePostion(
            id: 343,
            gmvid: 5433,
            line: "53",
            icon: "🚍",
            from: "Małopanewska", to: "Legnicka",
            delay: 5,
            location: CLLocationCoordinate2D(latitude: CLLocationDegrees(53.4), longitude: CLLocationDegrees(14.5528))))
    }
    
}
