//
//  CitySeeder.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 31.08.25.
//

//import Foundation

import SwiftUI
import RealmSwift

struct CitySeeder {
    static func seedIfNeeded() {
        let realm = try! Realm()

        // Если база пустая
        if realm.isEmpty {

            let sampleCities: [RealmCity] = [
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Paris"
                    c.lat = 48.8566
                    c.lon = 2.3522
                    c.country = "FR"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "New York"
                    c.lat = 40.7128
                    c.lon = -74.0060
                    c.country = "US"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "London"
                    c.lat = 51.5074
                    c.lon = -0.1278
                    c.country = "GB"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Rome"
                    c.lat = 41.9028
                    c.lon = 12.4964
                    c.country = "IT"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Tokyo"
                    c.lat = 35.6895
                    c.lon = 139.6917
                    c.country = "JP"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Barcelona"
                    c.lat = 41.3851
                    c.lon = 2.1734
                    c.country = "ES"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Dubai"
                    c.lat = 25.2048
                    c.lon = 55.2708
                    c.country = "AE"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Bangkok"
                    c.lat = 13.7563
                    c.lon = 100.5018
                    c.country = "TH"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Istanbul"
                    c.lat = 41.0082
                    c.lon = 28.9784
                    c.country = "TR"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Prague"
                    c.lat = 50.0755
                    c.lon = 14.4378
                    c.country = "CZ"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Amsterdam"
                    c.lat = 52.3676
                    c.lon = 4.9041
                    c.country = "NL"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Vienna"
                    c.lat = 48.2100
                    c.lon = 16.3738
                    c.country = "AT"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Berlin"
                    c.lat = 52.5200
                    c.lon = 13.4050
                    c.country = "DE"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Venice"
                    c.lat = 45.4408
                    c.lon = 12.3155
                    c.country = "IT"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Sydney"
                    c.lat = -33.8688
                    c.lon = 151.2093
                    c.country = "AU"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Los Angeles"
                    c.lat = 34.0522
                    c.lon = -118.2437
                    c.country = "US"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "San Francisco"
                    c.lat = 37.7749
                    c.lon = -122.4194
                    c.country = "US"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Cairo"
                    c.lat = 30.0444
                    c.lon = 31.2357
                    c.country = "EG"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Rio de Janeiro"
                    c.lat = -22.9068
                    c.lon = -43.1729
                    c.country = "BR"
                    return c
                }(),
                {
                    let c = RealmCity()
                    c._id = UUID().uuidString
                    c.name = "Kyiv"
                    c.lat = 50.4501
                    c.lon = 30.5234
                    c.country = "UA"
                    return c
                }(),
            ]

            try! realm.write {
                realm.add(sampleCities)
            }
        }
    }
}











//struct CitySeeder {
//  
//    static func seedIfNeeded() {
//        let realm = try! Realm()
//        
//        // Если база пустая
//        if realm.isEmpty {
//            let sampleCities: [OpenMapCity] = [
//                OpenMapCity(local_names: nil, name: "Paris", lat: 48.8566, lon: 2.3522, country: "FR", state: nil),
//                OpenMapCity(local_names: nil, name: "New York", lat: 40.7128, lon: -74.0060, country: "US", state: nil),
//                OpenMapCity(local_names: nil, name: "London", lat: 51.5074, lon: -0.1278, country: "GB", state: nil),
//                OpenMapCity(local_names: nil, name: "Rome", lat: 41.9028, lon: 12.4964, country: "IT", state: nil),
//                OpenMapCity(local_names: nil, name: "Tokyo", lat: 35.6895, lon: 139.6917, country: "JP", state: nil),
//                OpenMapCity(local_names: nil, name: "Barcelona", lat: 41.3851, lon: 2.1734, country: "ES", state: nil),
//                OpenMapCity(local_names: nil, name: "Dubai", lat: 25.2048, lon: 55.2708, country: "AE", state: nil),
//                OpenMapCity(local_names: nil, name: "Bangkok", lat: 13.7563, lon: 100.5018, country: "TH", state: nil),
//                OpenMapCity(local_names: nil, name: "Istanbul", lat: 41.0082, lon: 28.9784, country: "TR", state: nil),
//                OpenMapCity(local_names: nil, name: "Prague", lat: 50.0755, lon: 14.4378, country: "CZ", state: nil),
//                OpenMapCity(local_names: nil, name: "Amsterdam", lat: 52.3676, lon: 4.9041, country: "NL", state: nil),
//                OpenMapCity(local_names: nil, name: "Vienna", lat: 48.2100, lon: 16.3738, country: "AT", state: nil),
//                OpenMapCity(local_names: nil, name: "Berlin", lat: 52.5200, lon: 13.4050, country: "DE", state: nil),
//                OpenMapCity(local_names: nil, name: "Venice", lat: 45.4408, lon: 12.3155, country: "IT", state: nil),
//                OpenMapCity(local_names: nil, name: "Sydney", lat: -33.8688, lon: 151.2093, country: "AU", state: nil),
//                OpenMapCity(local_names: nil, name: "Los Angeles", lat: 34.0522, lon: -118.2437, country: "US", state: nil),
//                OpenMapCity(local_names: nil, name: "San Francisco", lat: 37.7749, lon: -122.4194, country: "US", state: nil),
//                OpenMapCity(local_names: nil, name: "Cairo", lat: 30.0444, lon: 31.2357, country: "EG", state: nil),
//                OpenMapCity(local_names: nil, name: "Moscow", lat: 55.7558, lon: 37.6173, country: "RU", state: nil),
//                OpenMapCity(local_names: nil, name: "Rio de Janeiro", lat: -22.9068, lon: -43.1729, country: "BR", state: nil)
//            ]
//            
//            // Преобразуем OpenMapCity в RealmCity и сохраняем
////            try! realm.write {
////                let realmCities = sampleCities.map { RealmCity(from: $0) }
////                realm.add(realmCities)
////            }
//          sampleCities.forEach { city in
//            try! realm.write{
//              realm.add(RealmCity(from: city))
//            }
//          }
//        }
//    }
//}
