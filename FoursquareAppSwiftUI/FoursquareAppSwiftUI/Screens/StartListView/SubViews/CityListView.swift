//
//  CityListView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 08.09.25.
//

import SwiftUI
import RealmSwift
import MapKit

struct CityListView: View {
    @EnvironmentObject var locationManager: LocationManager
    @ObservedResults(RealmCity.self) var cities
    @ObservedResults(RealmPlace.self) var places
    
  var body: some View {
    VStack {
      List {
        if cities.isEmpty {
          Section {
            VStack(spacing: 12) {
              Image(systemName: "wrongwaysign")
                .font(.largeTitle)
                .bold()
              Text("Unfortunately\nno cities were found")
                .multilineTextAlignment(.center)
                .font(.title2)
            }
            .foregroundStyle(.gray.opacity(0.8))
            .padding()
          }
        } else {
          ForEach(cities) { city in
            NavigationLink {
              let isUserCity = locationManager.userLocation != nil &&
              locationManager.isSamePlace(
                CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon),
                locationManager.userLocation!.coordinate,
                toleranceMeters: 3000
              )
              DiscoveryView(realmCity: city, isUserPosition: isUserCity)
            } label: {
              CityRow(city: city)
            }
          }
          .onDelete { indexSet in
            for index in indexSet {
              let city = cities[index]
              for place in city.places {
                $places.remove(place)
              }
              $cities.remove(city)
            }
          }
        }
      }
      //MARK: - debug view
      HStack {
        Text("Places: \(places.count)")
        
        Button("Remove All Places") {
          places.forEach { place in
            $places.remove(place)
          }
        }
        .disabled(places.isEmpty)
      }
    }
  }
}






