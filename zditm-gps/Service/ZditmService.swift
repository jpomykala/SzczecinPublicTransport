//
//  ZditmService.swift
//  zditm-gps
//
//  Created by Jakub Pomykała on 9/22/17.
//  Copyright © 2017 Jakub Pomykała. All rights reserved.
//

import Foundation
import Alamofire

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
                    completition(stops)
                } catch {
                    print("Error during encoding, result: \(response.result)")
                    completition([])
                }
            }
            completition([])
        }
    }
    
}
