//
//  DataManager.swift
//  SpacetiTask
//
//  Created by Radek Zmeskal on 05/06/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import Alamofire
import Unbox

let URL_WEATHER = "https://api.openweathermap.org/data/2.5/find"
let API_KEY = "c268566eacb5dae20a7f8d58fbd36583"

class DataManager: NSObject {
    
    class func getReport(lat: Double, lon: Double, completion: @escaping ([Report]?) -> Void) {
        guard let url = URL(string: URL_WEATHER) else {
            completion(nil)
            return
        }
        Alamofire.request(url,
                          method: .get,
                          parameters: [
                            "appid": API_KEY,
                            "lon": lon,
                            "lat": lat,
                            "cnt": 50,
                            "units": "metric",
                            ]
            )
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching from remote")
                    completion(nil)
                    return
                }
                
                guard let result = response.result.value as? [String: Any] else {
                    completion(nil)
                    return
                }
                
                guard let results = result["list"] as? [[String: Any]] else {
                    completion(nil)
                    return
                }
                
                var reports:[Report] = []
                
                for item in results {
                    do {
                        let report: Report = try unbox(dictionary: item)
                        reports.append(report)
                    } catch {
                        print("An error occurred: \(error)")
                    }
                }
                
                completion(reports)
        }
    }
    
    
}
