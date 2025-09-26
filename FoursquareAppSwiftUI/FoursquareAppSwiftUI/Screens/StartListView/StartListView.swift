//
//  TestView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 23.08.25.
//

import SwiftUI
import RealmSwift
import CoreLocation

struct StartListView: View {
  
  // MARK: - Properties
  @Environment(\.realm) var realm
  @EnvironmentObject var dataSource: PlacesDataSource
  @EnvironmentObject var locationManager: LocationManager
  
  @State private var searchText = ""
  @State private var showSearchBar = false
  @State private var showSearchSheet = false
  @State private var searchTerm = ""
  @State private var isLoadingLocation = false
  @State private var path: [RealmCity] = []   // Навигационный стек
  
  // MARK: - Body
  var body: some View {
    NavigationStack(path: $path) {
      ZStack {
        CityListView()
          .padding(.top, showSearchBar ? 70 : 0)
        
        VStack {
          if showSearchBar {
              CustomSearchBar(
                  text: $searchText,
                  placeholder: "enter city name"
              ) {
                  performSearch()
              }
              .padding(.top, 20)
          }
          Spacer()
        }
      }
      .ignoresSafeArea(.keyboard, edges: .bottom)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        principalToolbar()
        trailingToolbar()
      }
      .safeAreaInset(edge: .bottom) {
        exploreButton()
      }
      .onChange(of: locationManager.userLocation) { newLocation in
        if newLocation != nil && isLoadingLocation {
          fetchCurrentCity()
        }
      }
      .navigationDestination(for: RealmCity.self) { city in
        DiscoveryView(realmCity: city, isUserPosition: true)
      }
      .sheet(isPresented: $showSearchSheet) {
        CitySearchResultView(searchCityTerm: searchTerm)
          .environmentObject(dataSource)
      }
    }
  }
}

// MARK: - UI Functions
private extension StartListView {
    
    // Toolbar
    @ToolbarContentBuilder
    func principalToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Explore sights around the World")
                .font(.headline)
                .multilineTextAlignment(.center)
        }
    }
    
    @ToolbarContentBuilder
    func trailingToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation(.spring()) {
                    searchText = ""
                    showSearchBar.toggle()
                }
            } label: {
                Image(systemName: "magnifyingglass.circle")
                    .font(.title)
            }
        }
    }
    
    // Explore button
    @ViewBuilder
    func exploreButton() -> some View {
        Button {
            isLoadingLocation = true
            if let userLocation = locationManager.userLocation {
                createRealmCityFromUserLocation(userLocation)
            } else {
                locationManager.requestPermissionAndStart()
            }
        } label: {
            HStack(spacing: 8) {
                if isLoadingLocation {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(.white)
                }
                Text("explore sights around me")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(Color.blue)
            .clipShape(Capsule())
            .frame(minWidth: 200)
        }
    }
}

// MARK: - Logic Functions
private extension StartListView {
    
    func performSearch() {
        let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return }
        
        searchTerm = term
        loadCities(term: term, limit: 15)
        showSearchSheet = true
        searchText = ""
    }
    
    func loadCities(term: String, limit: Int) {
        guard !term.isEmpty else { return }
        dataSource.loadCities(by: term, limit: limit)
    }
    
    func fetchCurrentCity() {
        locationManager.getCurrentCity { city in
            isLoadingLocation = false
            guard let city = city else {
                print("Не удалось получить город по геопозиции")
                return
            }
            let realmCity = RealmCity()
            realmCity.name = city.name
            if let userLocation = locationManager.userLocation {
                realmCity.lat = userLocation.coordinate.latitude
                realmCity.lon = userLocation.coordinate.longitude
            }
            path.append(realmCity)
        }
    }
    
    func createRealmCityFromUserLocation(_ location: CLLocation) {
        locationManager.getCurrentCity { realmCity in
            guard let realmCity else { return }
            path.append(realmCity)
            isLoadingLocation = false
        }
    }
}

//#Preview {
//    StartListView()
//        .environmentObject(PlacesDataSource(networkProvider: NetworkProvider()))
//        .environmentObject(LocationManager())
//}


