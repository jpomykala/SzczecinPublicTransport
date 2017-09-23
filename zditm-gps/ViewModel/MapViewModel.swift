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
    
    private var vehiclePositions: [VehiclePostion]
    private var vehicleStops: [VehicleStop]
    
    init(_ delegate: MapScreenProtocol){
        self.delegate = delegate
        self.zditmService = ZditmService()
        self.vehiclePositions = []
        self.vehicleStops = []
        self.locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        loadAllVehicleStops()
        scheduledTimerWithTimeInterval()
    }
    
    var vehicleMarkers: [VehicleAnnotation]{
        var output = [VehicleAnnotation]()
        for vehicle in vehiclePositions {
            let title = "Linia \(vehicle.line ?? "nieznana")"
            guard let location = vehicle.location else {continue}
            let annotation = VehicleAnnotation(vehicle)
            output.append(annotation)
        }
        return output
    }
    
    var vehicleStopMarkers: [MKPointAnnotation]{
        var annotations = [MKPointAnnotation]()
        for stop in vehicleStops {
            guard let location = stop.location else { continue }
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Przystanek \(stop.name ?? "nieznany")"
            annotations.append(annotation)
        }
        return annotations
    }
    
    func loadAllVehicleStops() {
        zditmService.fetchRoute(lineNumber: 0, completition:  { (stops) in
            if stops.isEmpty {
                print("Vehicle stop array is empty")
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
        self.updateVehiclePositions()
    }
    
    func updateVehiclePositions(){
        zditmService.fetchBuses { (vehicles) in
            if vehicles.isEmpty {
                print("Vehicle array is empty")
                return
            }
            self.vehiclePositions = vehicles
            self.delegate.updateView()
        }
    }
}
