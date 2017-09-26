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
            guard let data = response.data, let vehicles =  try? JSONDecoder().decode([VehiclePostion].self, from: data) else {
                print("Error during Vehicles decoding!")
                completition([])
                return
            }
            completition(vehicles)
        }
    }
    
    func fetchStops(lineNumber: Int, completition: @escaping (_ result: [VehicleStop]) -> Void){
        let url = baseUrl + "json/slupki.inc.php?linia=\(lineNumber)"
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data, let stops = try? JSONDecoder().decode([VehicleStop].self, from: data) else {
                print("Error during Stops decoding!")
                completition([])
                return
            }
            completition(stops)
        }
    }
    
    func fetchRoute(gmvid: Int, completition: @escaping (_ result: [CLLocationCoordinate2D]) -> Void){
        let url = baseUrl + "json/trasy.inc.php?gmvid=\(gmvid)"
        
        Alamofire.request(url).responseJSON{ response in
            guard let data = response.data, let geojson = try? JSONDecoder().decode(RouteGeoJson.self, from: data) else {
                print("Error during Stops decoding!")
                completition([])
                return
            }
            
            var routePoints = [CLLocationCoordinate2D]()
            geojson.features
                .map({$0.geometry})
                .map({$0.coordinates})
                .forEach({ (coordinateArray) in
                    for coord in coordinateArray {
                        let lat = CLLocationDegrees(coord[1])
                        let lng = CLLocationDegrees(coord[0])
                        routePoints.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                    }
                })
            completition(routePoints)
          
        }
        
    }

}
