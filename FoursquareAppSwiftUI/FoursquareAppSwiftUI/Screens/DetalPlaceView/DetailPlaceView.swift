//
//  PlacePhotoView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 26.10.2022.
//

import SwiftUI
import RealmSwift

struct DetailPlaceView: View {
    
    // MARK: - Properties
    let placeId: String
    let placeName: String
    let cityName: String
    let place: Place? // Optional Place
    
    @State private var selectedPhotoIndex: Int = 0
    @State private var showCarouselView = false
    @State private var showTips = false
    @State private var isAlreadySaved = false
    @State private var showNoLocationAlert = false
    
    @AppStorage("countColumns") private var columns: Int = 3
    
    @EnvironmentObject var dataSource: PlacesDataSource
    @EnvironmentObject var locationManager: LocationManager
    
    // MARK: - Initializers
    init(place: Place, cityName: String) {
        self.place = place
        self.placeId = place.id
        self.placeName = place.name
        self.cityName = cityName
    }
    
    init(realmPlace: RealmPlace, cityName: String) {
        self.place = nil
        self.placeId = realmPlace._id
        self.placeName = realmPlace.name
        self.cityName = cityName
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            GeometryReader { geo in
                photoGrid(geo: geo)
                    .task {
                        dataSource.loadPlacePhotos(id: placeId)
                        dataSource.loadPlaceTips(id: placeId)
                        // Check if already saved
                        checkIfAlreadySaved()
                    }
            }
            
            VStack {
                Spacer()
                addToFavoriteButton()
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showCarouselView) {
            FullScreenPhotoCarouselView(selectedIndex: $selectedPhotoIndex)
        }
        .sheet(isPresented: $showTips) {
            UsersTipsView(tips: dataSource.placeTips)
        }
        .navigationTitle(placeName)
        .toolbar { toolbarContent() }
        .alert("Cannot Save", isPresented: $showNoLocationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Location coordinates are missing. Unable to save this place.")
        }
      
    }
}

// MARK: - Private functions
private extension DetailPlaceView {
    
    // MARK: - Check if the place is already saved
    func checkIfAlreadySaved() {
        let realm = try! Realm()
        guard let city = realm.objects(RealmCity.self).first(where: { $0.name == cityName }) else {
            isAlreadySaved = false
            return
        }
        isAlreadySaved = city.places.contains(where: { $0._id == placeId })
    }
    
    // MARK: - Toggle button
    func addToFavoriteButton() -> some View {
        Button(action: { toggleFavorite() }) {
            HStack {
                Text("⭐️")
                Text(isAlreadySaved ? "Remove from Favorite" : "Add to Favorite")
                    .bold()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(isAlreadySaved ? Color.red : Color.green)
            .clipShape(Capsule())
            .shadow(radius: 5)
        }
    }
    
    // MARK: - Toggle function: add or remove from Realm
  private func toggleFavorite() {
      let realm = try! Realm()
      
      try! realm.write {
          var city = realm.objects(RealmCity.self).first(where: { $0.name == cityName })
          if city == nil {
              let newCity = RealmCity()
              newCity._id = UUID().uuidString
              newCity.name = cityName
              realm.add(newCity)
              city = newCity
          }
          guard let city = city else { return }
          
          if let existing = city.places.first(where: { $0._id == placeId }) {
              // Remove from favorites
              realm.delete(existing)
              isAlreadySaved = false
          } else {
              // Determine coordinates
              var lat: Double?
              var lon: Double?
              
              if let place = place {
                  lat = place.geocodes.main?.latitude
                  lon = place.geocodes.main?.longitude
              } else if let userLocation = locationManager.userLocation {
                lat = userLocation.coordinate.latitude
                lon = userLocation.coordinate.longitude
              }
              
              guard let latitude = lat, let longitude = lon else {
                  showNoLocationAlert = true
                  return
              }
              
              // Add to favorites
              let favoritePlace = RealmPlace()
              favoritePlace._id = placeId
              favoritePlace.name = placeName
              favoritePlace.lat = latitude
              favoritePlace.lon = longitude
              
              city.places.append(favoritePlace)
              isAlreadySaved = true
          }
      }
  }
  
    // MARK: - Grid layout helper
    func columns(size: CGSize,
                 countColumn: Int,
                 spacing: CGFloat = 3,
                 edgePadding: CGFloat = 3) -> [GridItem] {
        let totalSpacing = spacing * CGFloat(countColumn - 1) + edgePadding * 2
        let itemWidth = (size.width - totalSpacing) / CGFloat(countColumn)
        return Array(repeating: GridItem(.fixed(itemWidth), spacing: spacing),
                     count: countColumn)
    }
    
    // MARK: - Photo grid
    func photoGrid(geo: GeometryProxy) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns(size: geo.size, countColumn: columns),
                      spacing: 3) {
                ForEach(dataSource.placePhotos.indices, id: \.self) { index in
                    let photoItem = dataSource.placePhotos[index]
                    Button {
                        selectedPhotoIndex = index
                        showCarouselView = true
                    } label: {
                        DetailGridCell(photoItem: photoItem)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                showTips.toggle()
            } label: {
                Text("Tips(\(dataSource.placeTips.count))").bold()
            }
            
            Menu {
                Text("Cell size")
                Button { columns = 3 } label: { Text("Small x3") }
                Button { columns = 2 } label: { Text("Medium x2") }
                Button { columns = 1 } label: { Text("Large x1") }
            } label: {
                Image(systemName: "eyeglasses")
            }
        }
    }
}
