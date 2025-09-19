//
//  CityListView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 08.09.25.
//

import SwiftUI
import RealmSwift

struct CityListView: View {
   // @Environment(\.realm) var realm
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
                //
                for place in city.places {
                  $places.remove(place)
                }
                $cities.remove(city)
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }
          }
          .onDelete { indexSet in
            for index in indexSet {
              let city = cities[index]
              // Удаляем все плейсы города из Realm
              for place in city.places {
                $places.remove(place)
              }
              // Удаляем сам город
              $cities.remove(city)
            }
          }
        }
      }
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








////MARK: - list of cities downloaded from realm
//struct CityListView: View {
//    @Environment(\.realm) var realm
//    @ObservedResults(RealmCity.self) var cities
//    @ObservedResults(RealmPlace.self)  var places
//   // var onDelete: ((RealmCity) -> Void)?  // 👉 замыкание для удаления
//    
//  var body: some View {
//    VStack {
//      List {
//        if cities.isEmpty {
//          Section {
//            VStack(spacing: 12) {
//              Image(systemName: "wrongwaysign")
//                .font(.largeTitle)
//                .bold()
//              Text("Unfortunately\nno cities were found")
//                .multilineTextAlignment(.center)
//                .font(.title2)
//            }
//            .foregroundStyle(.red)
//            .padding()
//          }
//        } else {
//          ForEach(cities) { city in
//            NavigationLink {
//              DiscoveryView(realmCity: city, isUserPosition: false)
//            } label: {
//              CityRow(city: city)
//            }
//            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//              Button(role: .destructive) {
//                $cities.remove(city)
//                //MARK: - delete
//              } label: {
//                Label("Delete", systemImage: "trash")
//              }
//            }
//          }
//         // .onDelete(perform: $cities.remove)
//          .onDelete { indexSet in
//              for index in indexSet {
//                  let city = cities[index]
//
//                  // сначала удаляем все places у города
//                  for place in city.places {
//                      $places.remove(place)
//                  }
//
//                  // теперь удаляем сам город
//                  $cities.remove(city)
//              }
//          }
//        }
//        
//      }
//      Text("Places: \(places.count)")
//    }
//    
//  }
//
//}







