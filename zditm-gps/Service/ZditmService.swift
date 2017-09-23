//
//  ZditmService.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/22/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

class ZditmService  {

    let baseUrl = "http://www.zditm.szczecin.pl/"
    
    func fetchBuses(completition: @escaping (_ result: [VehiclePostion]) -> Void) {
        let url = baseUrl + "json/pojazdy.inc.php"
        Alamofire.request(url).responseJSON { response in
            
            if let data = response.data {
                do {
                    let vehicles = try JSONDecoder().decode([VehiclePostion].self, from: data)
                    completition(vehicles)
                } catch {
                    print("Error during encoding, result: \(response.result)")
                    completition([])
                }
            }
            completition([])
        }
    }
    
    func fetchRoute(lineNumber: Int, completition: @escaping (_ result: [VehicleStop]) -> Void){
        let url = baseUrl + "json/slupki.inc.php?linia=\(lineNumber)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                do {
                    let stops = try JSONDecoder().decode([VehicleStop].self, from: data)
                    let mergedStops = stops
                        .map({ (stop) -> VehicleStop in
                            let stopsById = stops.filter({$0.name == stop.name!})
                            let sumLat = stopsById.reduce(0.0, { (result, stop) -> Double in
                                return result + Double(stop.location!.latitude)
                            })
                            
                            let sumLon = stopsById.reduce(0.0, { (result, stop) -> Double in
                                return result + Double(stop.location!.longitude)
                            })
                            
                            let avgLat = sumLat / Double(stopsById.count)
                            let avgLon = sumLon / Double(stopsById.count)
                            let avgCoordinates = CLLocationCoordinate2D(
                                latitude: CLLocationDegrees(avgLat),
                                longitude: CLLocationDegrees(avgLon))

                            return VehicleStop(id: stop.id, location: avgCoordinates, name: stop.name, groupId: stop.groupId)
                        })
                    
                    var uniqueStops = [VehicleStop]()
                    for stop in mergedStops{
                        if uniqueStops.contains(stop){
                            continue
                        }
                        uniqueStops.append(stop)
                    }

                    completition(uniqueStops)
                } catch {
                    print("Error during encoding, result: \(response.result)")
                    completition([])
                }
            }
            completition([])
        }
    }
    
}
