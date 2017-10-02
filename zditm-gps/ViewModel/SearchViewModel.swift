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
    private var filteredVehicles: [ResultRowModelView]
    
    init(_ delegate: ResultSearchDelegate) {
        self.delegate = delegate
        self.zditmService = ZditmService()
        self.vehicles = []
        self.filteredVehicles = []
        
        self.zditmService.fetchBuses(success: { (vehicles) in
            self.vehicles = vehicles
        }) { (error) in
            self.vehicles = []
        }
    }
    
    func getCellViewModel(_ indexPath: IndexPath) -> ResultRowModelView {
        return filteredVehicles[indexPath.row]
    }
    
    var rows: Int {
        return filteredVehicles.count
    }
    
    func updateQuery(query: String) {
        self.filteredVehicles = []
        if query.isEmpty {
            self.filteredVehicles = self.vehicles.map { ResultRowModelView($0, isSummary: false) }
        } else {
            let tmp = filterVehiclesStartsWith(query: query, self.vehicles)
            let lines = getUniqueLines(tmp.map{ $0.line! }).sorted()
            for line in lines {
                var tmpByLine = tmp.filter { $0.line == line }
                tmpByLine
                    .map { ResultRowModelView($0, isSummary: false) }
                    .forEach({ (v) in
                        self.filteredVehicles.append(v)
                    })
                self.filteredVehicles.append(ResultRowModelView(tmpByLine[0], isSummary: true))
            }
        }
        self.delegate.updateView()
    }
    
    private func filterVehiclesStartsWith(query: String, _ input: [VehiclePostion]) -> [VehiclePostion] {
        return input
            .filter { $0.line != nil }
            .filter { $0.line!.starts(with: query) }
    }
    
    private func getUniqueLines(_ input: [String]) -> Set<String> {
        var output = Set<String>()
        input.forEach { output.insert($0) }
        return output;
    }
}
