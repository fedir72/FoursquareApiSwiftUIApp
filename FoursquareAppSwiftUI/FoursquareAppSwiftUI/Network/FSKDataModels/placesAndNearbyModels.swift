//
//  placesAndNearbyModels.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 27.08.2022.
//

import Foundation

struct PlacesNearbe: Decodable {
    let results: [Place]
}

struct Places: Decodable {
    let results: [Place]
    let context: Context
}
