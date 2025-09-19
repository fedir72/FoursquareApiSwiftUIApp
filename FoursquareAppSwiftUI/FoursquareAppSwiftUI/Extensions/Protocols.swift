//
//  Protocols.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 01.09.25.
//

protocol CityRepresentable {
  
  var name: String { get }
  var lat: Double { get }
  var lon: Double { get }
  var country: String? { get }
  var state: String? { get }
  
  
  var fullAddress: String { get }
  var coordinateText: String { get }
  
}

