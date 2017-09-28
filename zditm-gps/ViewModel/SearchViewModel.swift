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
    private var vehicles: [VehiclePostion]
    private var filteredVehicles: [VehiclePostion]
    
    init(_ delegate: ResultSearchDelegate) {
        self.delegate = delegate
        self.zditmService = ZditmService()
        self.vehicles = []
        self.filteredVehicles = []
        self.zditmService.fetchBuses { (vehicles) in
            self.vehicles = vehicles
        }
    }
    
    func getCellViewModel(_ indexPath: IndexPath) -> ResultRowModelView {
        return ResultRowModelView(filteredVehicles[indexPath.row])
    }
    
    var numberOfSections: Int {
        return filteredVehicles.count
    }
    
    func updateQuery(_ query: String) {
        if query.isEmpty {
            self.filteredVehicles = self.vehicles
        } else {
            self.filteredVehicles = vehicles
                .filter({$0.line != nil})
                .filter { (vehicle) -> Bool in
                    return vehicle.line!.contains(query)
            }
        }
        self.delegate.updateView()
    }
}
