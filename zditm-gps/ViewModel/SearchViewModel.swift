//
//  SearchViewModel.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/24/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import MapKit

class SearchViewModel {
    
    private var delegate: ResultSearchDelegate
    private var zditmService: ZditmService
    private var locationManager: CLLocationManager
    private var vehicles: [VehiclePostion]
    private var filteredVehicles: [VehiclePostion]
    
    init(_ delegate: ResultSearchDelegate) {
        self.delegate = delegate
        self.zditmService = ZditmService()

        
        self.locationManager = CLLocationManager()
        self.vehicles = []
        self.filteredVehicles = []
        self.zditmService.fetchBuses { (vehicles) in
            self.vehicles = vehicles
        }
    }
    
    var numberOfSections: Int {
        return filteredVehicles.count
    }
    
    func getTitle(indexPath: IndexPath) -> String {
        return "🚍 Linia \(filteredVehicles[indexPath.row].line ?? "nieznana linia")"
    }
    
    func getDelay(indexPath: IndexPath) -> String {
        let delay = filteredVehicles[indexPath.row].delay!
        if delay < 0 {
            return "Opóźnienie \(abs(delay)) min"
        }
        
        if delay > 0 {
            return "\(delay) min szybciej"
        }
        return "Zgodnie z rozkładem"
    }
    
    func getFrom(indexPath: IndexPath) -> String {
        guard let from = filteredVehicles[indexPath.row].from else {
            return "nieznane"
        }
        
        if from.isEmpty {
            return "nieznane"
        }
        
        return from
    }
    
    func getTo(indexPath: IndexPath) -> String {
        guard let to = filteredVehicles[indexPath.row].to else {
            return "nieznane"
        }
        
        if to.isEmpty {
            return "nieznane"
        }
        
        return to
    }
    
    func updateQuery(_ query: String) {
        self.filteredVehicles = vehicles
            .filter({$0.line != nil})
            .filter { (vehicle) -> Bool in
                return vehicle.line!.contains(query)
        }
        self.delegate.updateView()
    }
}
