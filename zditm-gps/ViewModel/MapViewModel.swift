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
    private var routePoints: [CLLocationCoordinate2D]
    private var stops: [VehicleStop]
    
    init(_ delegate: MapScreenProtocol) {
        self.delegate = delegate
        self.zditmService = ZditmService()
        self.locationManager = CLLocationManager()
        self.vehicles = []
        self.routePoints = []
        self.stops = []
        
        locationManager.requestWhenInUseAuthorization()
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
    
    var vehicleRoute : MKPolyline {
        let polyline = MKPolyline(coordinates: self.routePoints, count: self.routePoints.count)
        return polyline
    }
    
    var vehicleStops : [MarkerViewModel] {
        return stops
            .filter({ $0.location != nil})
            .map { (stop) -> MarkerViewModel in
                return MarkerViewModel(stop)
        }
    }
    
    private func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.updateVehiclePositions), userInfo: nil, repeats: true)
    }
    
    @objc private func updateVehiclePositions(){
        print("Refreshing vehicles")
        zditmService.fetchBuses { (vehicles) in
            if vehicles.isEmpty {
                return
            }
            
            if self.highlightedLine.isEmpty {
                self.vehicles = vehicles
            } else{
                self.vehicles = vehicles.filter({$0.line == self.highlightedLine})
                if !self.vehicles.isEmpty{
                    self.higlightRoute(vehicle: self.vehicles[0])
                }
            }
            self.delegate.updateView()
        }
    }
    
    private func higlightRoute(vehicle: VehiclePostion){
        guard let gmvid = vehicle.gmvid, let line = vehicle.line else {
            return
        }
        
        self.zditmService.fetchRoute(gmvid: gmvid) { (points) in
            self.routePoints = points
            self.delegate.updateView()
        }
        
        self.zditmService.fetchStops(lineNumber: line) { (stops) in
            self.stops = stops
            self.delegate.updateView()
        }
    }
    
    func userRequestHighlightLine(line: String) {
        self.highlightedLine = line
        updateVehiclePositions()
    }
}
