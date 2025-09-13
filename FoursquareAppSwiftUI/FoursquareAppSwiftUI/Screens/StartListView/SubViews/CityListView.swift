//
//  CityListView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 08.09.25.
//

import SwiftUI


//MARK: - list of cities downloaded from realm

struct CityListView: View {
  var cities: [RealmCity]
  
  var body: some View {
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
          .foregroundStyle(.red)
          .padding()
        }
      } else {
        ForEach(cities) { city in
          NavigationLink {
            DiscoveryView(realmCity: city, isUserPosition: false)
          } label: {
            CityRow(city: city)
          }
          .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
              // удаление должно обрабатываться снаружи
            } label: {
              Label("Удалить", systemImage: "trash")
            }
          }
        }
      }
    }
  }
}


