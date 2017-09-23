//
//  MapViewModel.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/22/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import MapKit
import Alamofire

class MapViewModel {
    
    private var delegate: MapScreenProtocol
    private var zditmService: ZditmService
    private var locationManager: CLLocationManager
    private var timer = Timer()
    
    private var vehicles: [VehiclePostion]
    private var vehicleStops: [VehicleStop]
    
    init(_ delegate: MapScreenProtocol) {
        self.delegate = delegate
        self.zditmService = ZditmService()
        self.vehicles = []
        self.vehicleStops = []
        self.locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        loadAllVehicleStops()
        updateVehiclePositions()
        scheduledTimerWithTimeInterval()
    }
    
    var vehicleMarkers: [CustomAnnotation]{
        return vehicles
            .filter({ $0.location != nil})
            .map { (vehicle) -> CustomAnnotation in
            let text = "Linia \(vehicle.line ?? "nieznana")"
                return CustomAnnotation(title: "🚍",
                                        coordinate: vehicle.location!,
                                        color: UIColor(hexString: "#64B5F6"),
                                        subtitle: text,
                                        type: .BUS)
        }
    }
    
    var stopMarkers: [CustomAnnotation]{
        return vehicleStops
            .filter({ $0.location != nil})
            .map { (stop) -> CustomAnnotation in
                let text = "Przystanek \(stop.name ?? "nieznany")"
                return CustomAnnotation(title: "P",
                                        coordinate:stop.location!,
                                        color: UIColor(hexString: "#FF7043"),
                                        subtitle: text,
                                        type: .STOP)
        }
    }
    
    func loadAllVehicleStops() {
        zditmService.fetchRoute(lineNumber: 0, completition:  { (stops) in
            if stops.isEmpty {
                return
            }
            self.vehicleStops = stops
            self.delegate.updateView()
        })
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        print("updatind vehicle positions")
        DispatchQueue.main.async {
            self.updateVehiclePositions()
        }
    }
    
    func updateVehiclePositions(){
        zditmService.fetchBuses { (vehicles) in
            if vehicles.isEmpty {
                return
            }
            self.vehicles = vehicles
            self.delegate.updateView()
        }
    }
}
