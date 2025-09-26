//
//  RealmCityPlaceList.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 19.09.25.
//
import SwiftUI
import RealmSwift

struct RealmCityPlacesList: View {
    @ObservedResults(RealmPlace.self) var places  
    @ObservedRealmObject var city: RealmCity      
    
    var filteredPlaces: [RealmPlace] {
        city.places.sorted(by: { $0.name < $1.name })
    }
    
    var body: some View {
        List {
            if filteredPlaces.isEmpty {
                Text("No favorites yet")
                    .foregroundColor(.secondary)
            } else {
                ForEach(filteredPlaces) { place in
                    NavigationLink {
                        DetailPlaceView(realmPlace: place, cityName: city.name)
                    } label: {
                      PlaceRow(realmPlace: place)
                      .frame(height:50)
                    }
                }
                .onDelete(perform: deletePlaces)
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    private func deletePlaces(at offsets: IndexSet) {
        for index in offsets {
            let place = filteredPlaces[index]
            $places.remove(place)
        }
    }
}







//struct RealmCityPlacesList: View {
//    let city: RealmCity
//     @ObservedResults(RealmPlace.self) var places
//  
//    var body: some View {
//        List {
//            ForEach(places) { place in
//                NavigationLink {
//                    DetailPlaceView(realmPlace: place, cityName: city.name)
//                } label: {
//                    RealmPlaceRow(place: place)
//                }
//            }
//            .onDelete { indexSet in
//                deletePlaces(at: indexSet)
//            }
//        }
//        .listStyle(GroupedListStyle())
//    }
//    
//    private func deletePlaces(at offsets: IndexSet) {
//        guard let realm = city.realm else { return }
//        try? realm.write {
//            offsets.map { city.places[$0] }
//                   .forEach { realm.delete($0) }
//        }
//    }
//}
