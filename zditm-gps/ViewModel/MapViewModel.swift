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
    
    init(_ delegate: MapScreenProtocol) {
        self.delegate = delegate
        self.zditmService = ZditmService()
        self.vehicles = []
        self.routePoints = []
        self.locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
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

    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
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
                self.vehicles.forEach({ (vehicle) in
                    self.higlightRoute(gmvid: vehicle.gmvid!)
                })
            }
            self.delegate.updateView()
        }
    }
    
    
    func higlightRoute(gmvid: Int){
        self.zditmService.fetchRoute(gmvid: gmvid) { (points) in
            self.routePoints = points
            self.delegate.updateView()
        }
    }
    
    func highlightLine(line: String) {
        self.highlightedLine = line
        updateVehiclePositions()
    }
}
