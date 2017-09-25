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
    private var stops: [VehicleStop]
    
    init(_ delegate: MapScreenProtocol) {
        self.delegate = delegate
        self.zditmService = ZditmService()
        self.vehicles = []
        self.stops = []
        self.locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        updateVehiclePositions()
        scheduledTimerWithTimeInterval()
    }
    
    var vehicleMarkers: [MarkerViewModel]{
        return vehicles
            .filter({ $0.location != nil})
            .map { (vehicle) -> MarkerViewModel in
                return MarkerViewModel(vehicle)
        }
    }
    
    func loadStops(line: Int) {
        zditmService.fetchRoute(lineNumber: line, completition:  { (stops) in
            if stops.isEmpty {
                return
            }
            self.stops = stops
            self.delegate.updateView()
        })
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        DispatchQueue.main.async {
            self.updateVehiclePositions()
        }
    }
    
    func updateVehiclePositions(){
        print("Refreshing vehicles")
        zditmService.fetchBuses { (vehicles) in
            if vehicles.isEmpty {
                return
            }
            self.vehicles = vehicles
            self.delegate.updateView()
        }
    }
}
