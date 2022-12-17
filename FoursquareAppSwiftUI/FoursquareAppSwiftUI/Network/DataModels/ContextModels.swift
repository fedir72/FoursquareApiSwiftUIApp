//
//  ContextModels.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 27.08.2022.
//

import Foundation

struct Context: Decodable {
let geo_bounds: GeoBounds
}

struct GeoBounds: Decodable {
let circle: Circle
}

struct Circle: Decodable {
   let center: GeoPoint
   let radius: Int
}


/*
"context": {
    "geo_bounds": {
        "circle": {
            "center": {
                "latitude": 49.82850646972656,
                "longitude": 36.326904296875
            },
            "radius": 22000
        }
    }
}
*/

