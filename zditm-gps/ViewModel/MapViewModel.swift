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
    private var highlightedLine = ""
    
    private var vehicles: [VehiclePostion]
    
    init(_ delegate: MapScreenProtocol) {
        self.delegate = delegate
        self.zditmService = ZditmService()
        self.vehicles = []
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
            
            if self.highlightedLine.isEmpty {
                self.vehicles = vehicles
            } else{
                self.vehicles = vehicles.filter({$0.line == self.highlightedLine})
            }
            self.delegate.updateView()
        }
    }
    
    func highlightLine(line: String) {
        self.highlightedLine = line
        updateVehiclePositions()
    }
}
