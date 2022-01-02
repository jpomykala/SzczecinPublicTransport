//
//  LineRow.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 02/01/2022.
//  Copyright © 2022 Jakub Pomykała. All rights reserved.
//

import SwiftUI
import MapKit

struct LineRow: View {
    
    let vehiclePostion: VehiclePostion
    var delay = 0
    var status: String
    var color: Color
    init(vehiclePostion: VehiclePostion){
        self.vehiclePostion = vehiclePostion
        self.delay = vehiclePostion.delay ?? 0
        
        self.status = ""
        self.color = Color.gray
        if self.delay > 0 {
            self.status = "\(self.delay) min opóźniony"
            self.color = Color.red
        }
        
        if self.delay == 0 {
            self.status = "zgodnie z rozkładem"
            self.color = Color.green
        }
        
        if self.delay < 0 {
            self.status = "\(abs(self.delay)) min szybciej"
            self.color = Color.orange
        }
        
        
    }
    
    
    var body: some View {
        
        VStack{
            HStack{
                Text(vehiclePostion.line ?? "?")
                    .font(.system(size: 32).weight(.bold))
                Spacer()
                ZStack{
                    color.ignoresSafeArea()
                    Text(status)
                        .fontWeight(.bold)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                        .foregroundColor(.white)
                    
                }
                .frame(width: 250, height: 32, alignment: .center)
                .cornerRadius(16)
            }
            
            HStack{
                Text(vehiclePostion.from ?? "?")
                Image(systemName: "arrow.forward")
                    .foregroundColor(.gray)
                Text(vehiclePostion.to ?? "?").frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(8)
        
    }
}

struct LineRow_Previews: PreviewProvider {
    static var previews: some View {
        LineRow(vehiclePostion: VehiclePostion(id: 3838, gmvid: 84483, line: "153", icon: "🚊", from: "Moja ulica", to: "Nie moja ulica", delay: 0, location: CLLocationCoordinate2D(latitude: CLLocationDegrees(53), longitude: CLLocationDegrees(13))))
    }
}
