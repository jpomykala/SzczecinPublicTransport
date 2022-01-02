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
    
    private var zditmService: ZditmService
    private var locationManager: CLLocationManager
    private var highlightedLine: String?
    private var highlightedVehicle: Int?
    
    private var vehicles: [VehiclePostion]
    private var routePoints: [CLLocationCoordinate2D]
    private var stops: [VehicleStop]
    
    init() {
        
        self.zditmService = ZditmService()
        self.locationManager = CLLocationManager()
        self.vehicles = []
        self.routePoints = []
        self.stops = []
        
        locationManager.requestWhenInUseAuthorization()
        updateVehiclePositions()
        Timer.scheduledTimer(timeInterval: 35, target: self, selector: #selector(self.updateVehiclePositions), userInfo: nil, repeats: true)
    }
    
    var vehicleMarkers: [MarkerViewModel]{
        return vehicles.filter{ $0.location != nil}.map { MarkerViewModel($0) }
    }
    
    var vehicleRoute : MKPolyline {
        let polyline = MKPolyline(coordinates: self.routePoints, count: self.routePoints.count)
        return polyline
    }
    
    var vehicleStops : [MarkerViewModel] {
        return stops.filter{ $0.location != nil}.map { MarkerViewModel($0) }
    }
    
    @objc private func updateVehiclePositions(){
        print("Refreshing vehicles")
        zditmService.fetchBuses(success: { (vehicles) in
            
            if self.highlightedLine == nil && self.highlightedVehicle == nil {
                self.vehicles = vehicles
                self.stops = []
                self.routePoints = []
                
            } else if(self.highlightedLine != nil) {
                self.vehicles = vehicles.filter({$0.line == self.highlightedLine})
                if !self.vehicles.isEmpty{
                    self.higlightRoute(vehicle: self.vehicles[0])
                }
            } else if(self.highlightedVehicle != nil) {
                self.vehicles = vehicles.filter({$0.id == self.highlightedVehicle})
                if !self.vehicles.isEmpty{
                    self.higlightRoute(vehicle: self.vehicles[0])
                }
            }
            
        }) { (error) in
            
        }
    }
    
    private func higlightRoute(vehicle: VehiclePostion) {
        guard let gmvid = vehicle.gmvid, let line = vehicle.line else {
            return
        }
        
        self.zditmService.fetchRoute(gmvid: gmvid) { (points) in
            self.routePoints = points
            
        }
        
        self.zditmService.fetchStops(lineNumber: line) { (stops) in
            self.stops = stops
            
        }
    }
    
    func userHiglightRequest(id: Int) {
        self.highlightedVehicle = id
        self.highlightedLine = nil
        updateVehiclePositions()
    }
    
    func userHiglightRequest(line: String) {
        self.highlightedVehicle = nil
        self.highlightedLine = line
        updateVehiclePositions()
    }
    
    func userResetSelectionRequest(){
        self.highlightedLine = nil
        self.highlightedVehicle = nil
        updateVehiclePositions()
    }
}
