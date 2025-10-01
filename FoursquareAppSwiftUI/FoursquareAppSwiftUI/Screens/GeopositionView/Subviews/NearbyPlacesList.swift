//
//  nearbyPlacesListView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 19.09.25.
//

import SwiftUI

struct NearbyPlacesList: View {
    let places: [Place]
    let cityName: String
    
    var body: some View {
        ZStack {
            if places.isEmpty {
                LoadingView()
            }
          
                List(places, id: \.name) { place in
                    NavigationLink(destination: DetailPlaceView(place: place, cityName: cityName)) {
                       // SearchRow(place: place)
                      PlaceRow(place: place)
                            .frame(height:50)
                    }
                }
        
        }
        .listStyle(GroupedListStyle())
    }
}

//#Preview {
//  NearbyPlacesListView(places: <#[Place]#>, cityName: <#String#>)
//}
