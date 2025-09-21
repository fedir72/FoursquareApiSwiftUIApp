//
//  RealmModels.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 31.08.25.
//

import SwiftUI
import RealmSwift

class RealmCity: Object,
                 ObjectKeyIdentifiable,
                 CityRepresentable {
  
  //var state: String?
  
  @Persisted(primaryKey: true) var _id: String
  @Persisted var name: String = ""
  @Persisted var lat: Double = 0
  @Persisted var lon: Double = 0
  @Persisted var country: String?
  @Persisted var state: String?
  //MARK: - persisted favorite places
  @Persisted var places = List<RealmPlace>()
  
  // Инициализация из OpenMapCity
  convenience init(from city: OpenMapCity) {
    self.init()
    self.name = city.name
    self.lat = city.lat
    self.lon = city.lon
    self.country = city.country
    self._id = UUID().uuidString   
  }
  
  // Вычисляемые свойства для отображения
  var coordinateText: String {
    "Coordinate: lat: \(lat), lon: \(lon)"
  }
  
  var fullAddress: String {
    var components: [String] = [name]
    if let country = country, !country.isEmpty {
      components.append(country)
    }
//    if let state {
//      
//    }
    return components.joined(separator: ", ")
  }
  
}


