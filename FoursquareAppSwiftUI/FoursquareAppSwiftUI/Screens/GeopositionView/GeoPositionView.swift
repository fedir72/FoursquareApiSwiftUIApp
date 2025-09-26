//
//  GeoPositionView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//
//
import SwiftUI
import MapKit
import RealmSwift

struct GeoPositionView: View {
  
    @EnvironmentObject var dataSource: PlacesDataSource
    
    @State private var showMap = false
    @State private var searchTerm = ""
    @State private var showSearchBar = false
    @State private var showFavorites = false
    
    @Binding var showCategories: Bool
    @Binding var searchCategoryIndex: Int
    
    let realmCity: RealmCity
    let isUserPosition: Bool
    
    
    
  var body: some View {
    NavigationView {
      ZStack {
        VStack {
          Toggle(isOn: $showFavorites) {
            Text("Show Favorites (\(realmCity.places.count))")
              .foregroundColor(.blue)
              .font(.headline)
          }
          .padding(.horizontal, 15)
          .tint(.green)
          .onChange(of: showFavorites) { newValue in
            if newValue && showSearchBar {
              withAnimation(.spring()) {
                showSearchBar = false
                
              }
            }
          }
          
          ZStack {
            NearbyPlacesList(places: dataSource.nearbyPlaces, cityName: realmCity.name)
              .offset(x: showFavorites ? -UIScreen.main.bounds.width : 0)
              .animation(.easeInOut, value: showFavorites)
            RealmCityPlacesList(city: realmCity)
              .offset(x: showFavorites ? 0 : UIScreen.main.bounds.width)
              .animation(.easeInOut, value: showFavorites)
          }
          .task {
            dataSource.loadNearbyPlaces(
              for: realmCity.name,
              lat: realmCity.lat,
              long: realmCity.lon
            )
          }
          .onChange(of: searchCategoryIndex) { _ in
            getPlaces(category: String(searchCategoryIndex))
          }
        }
        .padding(.top, showSearchBar ? 70 : 0)
        
        // SearchBar появляется поверх контента
        VStack {
          if showSearchBar {
            CustomSearchBar(
              text: $searchTerm,
              placeholder: "Search for places"
            ) {
              performSearch()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .transition(.move(edge: .top).combined(with: .opacity))
          }
          Spacer()
        }
      }
      .navigationTitle(realmCity.name)
      .toolbar {
        topBarContent()
      }
      .sheet(isPresented: $showMap) {
        LocationMapView(
            realmCity: realmCity,
            annotationItems: showFavorites ? Array(realmCity.places) : Array(dataSource.nearbyPlaces.map { RealmPlace(from: $0) }),
            isUserPosition: isUserPosition
        )
      }
    }
    .disabled(showCategories)
  }
}

// MARK: - Private Methods
private extension GeoPositionView {
  func getPlaces(term: String? = nil, category: String? = nil) {
    dataSource.getPlaces(term: term,
                         category: category,
                         lat: realmCity.lat,
                         long: realmCity.lon)
  }
  
  func performSearch() {
    let trimmed = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    getPlaces(term: trimmed)
    searchTerm = ""
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
      .disabled(showFavorites)
    }
   
    
    ToolbarItemGroup(placement: .navigationBarTrailing) {
      Button {
        showMap.toggle()
      } label: {
        Image(systemName: "globe")
          .font(.title3)
      }
      Button {
        withAnimation(.spring()) {
          searchTerm = ""
          showSearchBar.toggle()
        }
      } label: {
        Image(systemName: "magnifyingglass.circle")
          .font(.title3)
      }
      .disabled(showFavorites)
    }
  }
}
