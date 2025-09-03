//
//  OpenWeaterModels.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 28.08.25.
//

import Foundation


struct OpenMapCity: Decodable ,
                    Identifiable,
                    CityRepresentable {
  
    var id: String { "\(name)-\(country ?? "not found")-\(lat)-\(lon)" }
  
    let local_names: [String:String]?
    let name: String
    let lat: Double
    let lon: Double
    let country: String?
    let state: String?
}

extension OpenMapCity {
  
    var coordinateText: String {
        return "lat: \(lat), lon: \(lon)"
    }
    
    var fullAddress: String {
        var components: [String] = []
        components.append(name)
        if let state = state, !state.isEmpty {
            components.append(state)
        }
        if let country = country, !country.isEmpty {
            components.append(country)
        }
        return components.joined(separator: ", ")
    }
  
  var localNamesStrings: [String] {
      guard let localNames = local_names else { return [] }
      return localNames.map { (lang, name) in
          "\(lang): \(name)"
      }
  }
  
     var allLocalNamesString: String {
         return localNamesStrings.joined(separator: "\n")
     }
  
}



