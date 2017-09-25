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
    
    func fetchRoute(lineNumber: Int, completition: @escaping (_ result: [VehicleStop]) -> Void){
        let url = baseUrl + "json/pojazdy.inc.php?gmvid=\(lineNumber)"
//        Alamofire.request(url).responseJSON { response in
//            guard let data = response.data, let stops = try? JSONDecoder().decode([].self, from: data) else {
//                print("Error during Stops decoding!")
//                completition([])
//                return
//            }
//            completition(stops)
//        }
    }
    
}
