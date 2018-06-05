//
//  Report.swift
//  SpacetiTask
//
//  Created by Radek Zmeskal on 05/06/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import Unbox
import MapKit

struct Report {
    let id: String
    let name: String
    let coord: CLLocationCoordinate2D
    let tempMin: Float
    let tempMax: Float
    let weather: String
}

extension Report: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        let lat: Double = try unboxer.unbox(keyPath: "coord.lat")
        let lon: Double = try unboxer.unbox(keyPath: "coord.lon")
        self.coord = try CLLocationCoordinate2DMake(lat, lon)
        self.tempMin = try unboxer.unbox(keyPath: "main.temp_min")
        self.tempMax = try unboxer.unbox(keyPath: "main.temp_max")
        let weathers: [[String: Any]] = try unboxer.unbox(keyPath: "weather")
        if weathers.count > 0, let weather = weathers[0]["main"] as? String {
            self.weather = weather
        } else {
            self.weather = ""
        }
    }
}
    

//    id    2641549
//    name    "Newtonhill"
//    coord
//    lat    57.0333
//    lon    -2.15
//    main
//    temp    275.15
//    pressure    1010
//    humidity    93
//    temp_min    275.15
//    temp_max    275.15
//    dt    1521204600
//    wind
//    speed    9.3
//    deg    120
//    gust    18
//    sys
//    country    ""
//    rain    null
//    snow    null
//    clouds
//    all    75
//    weather
//    0
//    id    311
//    main    "Drizzle"
//    description    "rain and drizzle"
//    icon    "09d"


