//
//  ContentView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import SwiftUI
import MapKit

struct GeoPositionView: View {
  
  @EnvironmentObject var dataSource: PlacesDataSource
  
  @State private var showMap = false
  @State private var showSearchAlert = false
  @State private var searchTerm = ""
  @State private var tempSearchTerm = ""
  
  @Binding var showCategories: Bool
  @Binding var searchCategoryIndex: Int
  
  let realmCity: RealmCity
  let isUserPosition: Bool
  
  @State private var showFavorites = false
  
  var body: some View {
    
    NavigationView {
      VStack{
        infoView()//MARK: - debug
        Toggle(isOn: $showFavorites) {
            Text("Show Favorites (\(realmCity.places.count))")
                .foregroundColor(.blue) // цвет текста
                .font(.headline)
        }
        .padding(.horizontal,15)
        .tint(.green)
        ZStack {
          NearbyPlacesList(places: dataSource.nearbyPlaces, cityName: realmCity.name)
            .offset(x: showFavorites ? -UIScreen.main.bounds.width : 0)
            .animation(.easeInOut, value: showFavorites)
          RealmCityPlacesList(city: realmCity)
            .offset(x: showFavorites ? 0 : UIScreen.main.bounds.width)
            .animation(.easeInOut, value: showFavorites)
        }
        .task { print("userposition",isUserPosition)}
        .task {
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
            annotationitems: dataSource.nearbyPlaces,
            isUserPosition: isUserPosition
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
  
}

// MARK: - Private Methods
private extension GeoPositionView {
    func loadNearbyPlaces() {
        dataSource.loadNearbyPlaces(for: realmCity.name,
                                    lat: realmCity.lat,
                                    long: realmCity.lon)
    }
    
    func getPlaces(term: String? = nil, category: String? = nil) {
        dataSource.getPlaces(term: term,
                             category: category,
                             lat: realmCity.lat,
                             long: realmCity.lon)
    }
    
    func infoView() -> some View {
        VStack(alignment: .leading) {
            Text("places: \(dataSource.nearbyPlaces.count), favorites( \(realmCity.places.count) )")
            Text("index: \(searchCategoryIndex)")
            Text("Coord: \(realmCity.lat) \(realmCity.lon)")
        }
    }
    
    func segmentPicker(selectedSegment: Binding<Int>, favoritesCount: Int) -> some View {
        Picker("", selection: selectedSegment) {
            Text("Search Results").tag(0)
            Text("Favorites(\(favoritesCount))").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
    
    @ToolbarContentBuilder
    func topBarContent() -> some ToolbarContent {
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






