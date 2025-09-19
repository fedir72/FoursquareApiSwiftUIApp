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
  
  // MARK: - properties
  @Environment(\.realm) var realm
  
  @EnvironmentObject var dataSource: PlacesDataSource
  @EnvironmentObject var locationManager: LocationManager
  
 // @ObservedResults(RealmCity.self) var cities
  
  @State private var searchText = ""
  @State private var showSearchBar = false
  
  @State private var showSearchSheet = false
  @State private var searchTerm = ""
  
  @State private var isLoadingLocation = false
  @State private var path: [RealmCity] = []   // 👉 стек навигации
  
  // MARK: - body
  var body: some View {
    NavigationStack(path: $path) {
      ZStack {
        CityListView()
          .padding(.top, showSearchBar ? 70 : 0)
        
        VStack {
          if showSearchBar {
            searchBarView()
              .padding(10)
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
     
      //MARK: - use current location
      .onChange(of: locationManager.userLocation) { newLocation in
          if newLocation != nil && isLoadingLocation {
              fetchCurrentCity()
          }
      }
      //MARK: - show DiscoveryView
      .navigationDestination(for: RealmCity.self) { city in
        DiscoveryView(realmCity: city, isUserPosition: true)
      }
      // MARK: - Sheet CitySearchResultView
      .sheet(isPresented: $showSearchSheet) {
          CitySearchResultView(searchCityTerm: searchTerm)
              .environmentObject(dataSource)
      }
    }
  }
}

// MARK: - private helpers
private extension StartListView {
  
  //MARK: - toolbarItems
  @ToolbarContentBuilder
  private func principalToolbar() -> some ToolbarContent {
      ToolbarItem(placement: .principal) {
          Text("Explore sights Around the World")
              .font(.headline)
              .multilineTextAlignment(.center)
      }
  }

  @ToolbarContentBuilder
  private func trailingToolbar() -> some ToolbarContent {
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
  
  //MARK: - fetchCurrentCity
  private func fetchCurrentCity() {
      locationManager.getCurrentCity { city in
          isLoadingLocation = false
          guard let city = city else {
              print("Не удалось получить город по геопозиции")
              return
          }

          // Сохраняем координаты в RealmCity
          let realmCity = RealmCity()
          realmCity.name = city.name
          if let userLocation = locationManager.userLocation {
              realmCity.lat = userLocation.coordinate.latitude
              realmCity.lon = userLocation.coordinate.longitude
          }

          // Добавляем город в стек навигации
          path.append(realmCity)
      }
  }
  
  func createRealmCityFromUserLocation(_ location: CLLocation) {
      let realmCity = RealmCity()
      realmCity.name = "Current City" // Или получаем из geocoder
      realmCity.lat = location.coordinate.latitude
      realmCity.lon = location.coordinate.longitude
      
      path.append(realmCity)
      isLoadingLocation = false
  }
  
  // MARK: - exploreButton()
  @ViewBuilder
  func exploreButton() -> some View {
      Button {
          isLoadingLocation = true
          
          // Если координаты уже есть, сразу используем
          if let userLocation = locationManager.userLocation {
              createRealmCityFromUserLocation(userLocation)
          } else {
              // Запрашиваем разрешение и ждём координаты
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
  
  
  
  
//  @ViewBuilder
//  private func exploreButton() -> some View {
//      Button {
//          isLoadingLocation = true
//          if locationManager.userLocation != nil {
//              fetchCurrentCity()
//          } else {
//              locationManager.requestPermissionAndStart()
//          }
//      } label: {
//          HStack(spacing: 8) {
//              if isLoadingLocation {
//                  ProgressView()
//                      .progressViewStyle(CircularProgressViewStyle(tint: .white))
//              } else {
//                  Image(systemName: "location.circle.fill")
//                      .foregroundColor(.white)
//              }
//              
//              Text("explore sights around me")
//                  .foregroundColor(.white)
//                  .font(.title2)
//          }
//          .padding(.vertical, 14)
//          .padding(.horizontal, 24)
//          .background(Color.blue)
//          .clipShape(Capsule())
//          .frame(minWidth: 200)
//      }
//  }
  
  private func performSearch() {
      let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !term.isEmpty else { return }

      searchTerm = term
      showSearchSheet = true
      searchText = ""
  }
  
  //MARK: - searchBarView()
 // @ViewBuilder
  private func searchBarView() -> some View {
    HStack {
      Button {
          performSearch()
      } label: {
          Image(systemName: "magnifyingglass")
      }
      .disabled(searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

      TextField("enter city name", text: $searchText)
          .textFieldStyle(PlainTextFieldStyle())
          .autocorrectionDisabled()
          .textInputAutocapitalization(.never)
          .onSubmit {
              performSearch()
          }

         if !searchText.isEmpty {
             Button(action: { searchText = "" }) {
                 Image(systemName: "xmark.circle.fill")
                     .foregroundColor(.gray)
             }
         }
     }
     .padding(10)
     .background(Color(.systemGray6))
     .clipShape(Capsule())
     .padding(.horizontal, 10)
     .shadow(radius: 1)
 
  }
  
  // MARK: - loadCities()
  private func loadCities(term: String, limit: Int) {
    guard !term.isEmpty else { return }
    dataSource.loadCities(by: term, limit: limit)
  }
}

#Preview {
  StartListView()
    .environmentObject(
      PlacesDataSource(networkProvider: NetworkProvider())
    )
}


