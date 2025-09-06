//
//  ContentView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import SwiftUI
import MapKit

struct GeoPositionView: View {
  
  // @EnvironmentObject var locationManager: LocationManager
  @EnvironmentObject var dataSource: PlacesDataSource
  
  @State private var showMap = false
  @State private var showSearchAlert = false
  @State private var searchTerm = ""
  @State private var tempSearchTerm = ""
  
  @Binding var showCategories: Bool
  @Binding var searchCategoryIndex: Int
  
  let realmCity: RealmCity
  
  var body: some View {
    
    NavigationView {
      VStack {
        infoView()
        nearbyPlacesList(places: dataSource.nearbyPlaces)
          .listStyle(GroupedListStyle())
          .task {
            print("task")
            dataSource.loadNearbyPlaces(
              for: realmCity.name,
              lat: realmCity.lat,
              long: realmCity.lon
            )
          }
          .onChange(of: searchTerm) { _ in
            getPlaces(term: searchTerm)
          }
          .onChange(of: searchCategoryIndex) { _ in
            getPlaces(category: String(searchCategoryIndex))
          }
          .sheet(isPresented: $showMap) {
            LocationMapView(
              realmCity: realmCity,
              annotationitems: dataSource.nearbyPlaces
            )
          }
      }
      .navigationTitle(realmCity.name)
      .toolbar {
        topBarContent()
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
    }
    .disabled(showCategories ? true : false)
  }
  
  // MARK: - Helper Methods
  private func loadNearbyPlaces() {
    dataSource.loadNearbyPlaces(
      for: realmCity.name,
      lat: realmCity.lat,
      long: realmCity.lon
    )
  }
  
  private func getPlaces(term: String? = nil, category: String? = nil) {
    dataSource.getPlaces(
      term: term,
      category: category,
      lat: realmCity.lat,
      long: realmCity.lon
    )
  }
  
  private func infoView() -> some View {
    VStack(alignment: .leading) {
      Text("places: \(dataSource.nearbyPlaces.count)")
      Text("index: \(searchCategoryIndex)")
      Text("term: \(searchTerm)")
    }
  }
  
  private func nearbyPlacesList(places: [Place]) -> some View {
    List {
      if places.isEmpty {
        LoadingView()
      }
      
      ForEach(places, id: \.name) { place in
        NavigationLink(destination: DetailPlaceView(place: place)) {
          SearchRow(place: place)
            .frame( height: 40)
        }
      }
    }
  }
  
  @ToolbarContentBuilder
  private func topBarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button {
        showCategories.toggle()
      } label: {
        Image(systemName: "list.bullet")
          .font(.title3)
      }
    }
    
    ToolbarItemGroup(placement: .navigationBarTrailing) {
      Button {
        showMap.toggle()
      } label: {
        Image(systemName: "globe")
          .font(.title3)
      }
      
      Button {
        tempSearchTerm = searchTerm
        showSearchAlert = true
      } label: {
        Image(systemName: "magnifyingglass")
          .font(.title3)
      }
    }
  }
  
}









