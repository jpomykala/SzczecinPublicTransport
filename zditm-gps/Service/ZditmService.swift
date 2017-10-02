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
    
    func fetchBuses(
        success completition: @escaping (_ result: [VehiclePostion]) -> (),
        failure onError: @escaping (_ error: String) -> ()) {
        let url = baseUrl + "json/pojazdy.inc.php"
        Alamofire.request(url).responseJSON { response in
            print("Success: \(response.result.isSuccess)")
            guard let data = response.data, let vehicles =  try? JSONDecoder().decode([VehiclePostion].self, from: data) else {
                print("Failure Reason: \(response.response?.statusCode ?? 0)")
                onError("Error during Vehicles decoding!")
                return
            }
            completition(vehicles)
        }
    }
    
    func fetchStopDepartureAlert(
        lineNumber: String,
        stopId: Int,
        success: @escaping (_ result: StopDepartureInfo) -> ()){
        let url = baseUrl + "json/tabliczka.inc.php?linia=\(lineNumber)&slupek=\(stopId)"
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data, let departureInfo = try? JSONDecoder().decode(StopDepartureInfo.self, from: data) else {
                return
            }
            success(departureInfo)
        }
    }
    
    func fetchStopDepartures(stopId: Int,success: @escaping (_ result: StopDepartureInfo) -> ()){
        let url = baseUrl + "json/slupekkursy.inc.php?slupek=\(stopId)"
        //FIX this - http://www.zditm.szczecin.pl/json/slupekkursy.inc.php?slupek=13
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data, let departureInfo = try? JSONDecoder().decode(StopDepartureInfo.self, from: data) else {
                return
            }
            success(departureInfo)
        }
    }
    
    func fetchStops(lineNumber: String, completition: @escaping (_ result: [VehicleStop]) -> Void) {
        print("Fetching stops for", lineNumber, "line")
        let url = baseUrl + "json/slupki.inc.php?linia=\(lineNumber)"
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data, let stops = try? JSONDecoder().decode([VehicleStop].self, from: data) else {
                print("Error during Stops decoding!")
                print("Failure Reason: \(response.response?.statusCode ?? 0)")
                completition([])
                return
            }
            if stops.count > 30 {
                completition([])
                return
            }
            completition(stops)
        }
    }
    
    func fetchAlerts(completition: @escaping (_ result: [Alert]) -> Void){
        let url = baseUrl + "json/zmianyrj.inc.php";
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data, let alerts = try? JSONDecoder().decode([Alert].self, from: data) else {
                print("Error during Alerts decoding!")
                print("Failure Reason: \(response.response?.statusCode ?? 0)")
                completition([])
                return
            }
            completition(alerts)
        }
    }
    
    func fetchRoute(gmvid: Int, completition: @escaping (_ result: [CLLocationCoordinate2D]) -> Void){
        print("Fetching stops for", gmvid, "gmvid")
        let url = baseUrl + "json/trasy.inc.php?gmvid=\(gmvid)"
        
        Alamofire.request(url).responseJSON{ response in
            guard let data = response.data, let geojson = try? JSONDecoder().decode(RouteGeoJson.self, from: data) else {
                print("Error during Stops decoding!")
                print("Failure Reason: \(response.response?.statusCode ?? 0)")
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
