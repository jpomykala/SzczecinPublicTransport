//
//  ResultSearchController.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/24/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import SlideOverCard

struct MyMainView: View {
    
    @ObservedObject var vehicles = Vehicles()

    

    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 53.4,
                longitude: 14.5528
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.16,
                longitudeDelta: 0.16
            )
        )
    
    var body: some View {
        
        VStack{
        ZStack{
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: vehicles.vehicles
            ){ vehicle in
                MapAnnotation(coordinate: vehicle.location!) {
                VehicleMarkerView(vehicle: vehicle)
                }
            }
                .ignoresSafeArea(.all)
            SlideOverCard() {
                VStack {
                    SearchBar(text: .constant("")).padding(.horizontal).padding(.top, 8)
                   List(){
                       ForEach(vehicles.vehicles) { vehiclePostion in
                           LineRow(vehiclePostion: vehiclePostion)
                        }
                    }
                    Spacer()
                }
            }
            
        }
        }
        

    }
}

struct MyMainView_Previews: PreviewProvider {
    static var previews: some View {
        MyMainView(vehicles: Vehicles())
    }
    
}
