//
//  ContentView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import SwiftUI
import MapKit

struct GeoPositionView: View {
  
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var dataSource: PlacesDataSource
    
    @State private var showMap = false
    @State private var searchTerm: String = ""
    @State private var showSearchAlert = false
    @State private var tempSearchTerm = ""
    
    @Binding var showCategories: Bool
    @Binding var searchCategoryIndex: Int
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("places: \(dataSource.nearbyPlaces.count)")
                    Text("index: \(searchCategoryIndex)")
                    Text("term: \(searchTerm)")
                }
                List {
                    if dataSource.nearbyPlaces.isEmpty {
                        Text("Did not find any places")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    
                    ForEach(dataSource.nearbyPlaces, id: \.name) { place in
                        NavigationLink(destination: DetailPlaceView(place: place)) {
                            SearchCellView(place: place)
                               .frame( height: 40)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .task { loadNearbyPlaces() }
                .onChange(of: locationManager.userLocation) { _ in
                    loadNearbyPlaces()
                }
                .onChange(of: searchTerm) { _ in
                    getPlaces(term: searchTerm)
                }
                .onChange(of: searchCategoryIndex) { _ in
                    getPlaces(category: String(searchCategoryIndex))
                }
                .sheet(isPresented: $showMap) {
                    LocationMapView(
                        showMap: $showMap,
                        region: locationManager.region,
                        annotationitems: dataSource.nearbyPlaces
                    )
                }
            }
            .navigationTitle("Nearest Places")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showCategories.toggle()
                    } label: {
                      Image(systemName: "list.bullet")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showMap.toggle()
                    } label: {
                        Image(systemName: "globe")
                    }
                    
                    Button {
                        tempSearchTerm = searchTerm
                        showSearchAlert = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .alert("Enter approximate search term",
                   isPresented: $showSearchAlert,
                   actions: {
                TextField("search term", text: $tempSearchTerm)
                Button("Search") { searchTerm = tempSearchTerm }
                Button("Cancel", role: .cancel) {
                  tempSearchTerm = ""
                }
            })
            //.task { loadNearbyPlaces() }
        }
        .disabled(showCategories ? true : false)
    }
    
    // MARK: - Helper Methods
    private func loadNearbyPlaces() {
        guard let location = locationManager.userLocation else { return }
        dataSource.loadNearbyPlaces(
            lat: location.coordinate.latitude,
            long: location.coordinate.longitude
        )
    }
    
    private func getPlaces(term: String? = nil, category: String? = nil) {
        guard let location = locationManager.userLocation else { return }
        dataSource.getPlaces(
            term: term,
            category: category,
            lat: location.coordinate.latitude,
            long: location.coordinate.longitude
        )
    }
}









