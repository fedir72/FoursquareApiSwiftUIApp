//
//  EquitableLocation.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 05.09.25.
//

// EquatableLocation.swift

import Foundation
import CoreLocation

/// Обёртка над CLLocationCoordinate2D, которая поддерживает Equatable
struct EquatableLocation: Equatable {
  let latitude: Double
  let longitude: Double
  
  init(coordinate: CLLocationCoordinate2D) {
    self.latitude = coordinate.latitude
    self.longitude = coordinate.longitude
  }
  
  var clLocationCoordinate2D: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
