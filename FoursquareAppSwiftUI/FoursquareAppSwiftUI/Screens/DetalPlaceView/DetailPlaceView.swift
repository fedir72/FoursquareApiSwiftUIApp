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
    let place: Place? 
    
    @State private var selectedPhotoIndex: Int = 0
    @State private var showCarouselView = false
    @State private var showTips = false
    @State private var isAlreadySaved = false
    @State private var showNoLocationAlert = false
    
    @AppStorage("countColumns") private var columns: Int = 3
    
    @EnvironmentObject var dataSource: PlacesDataSource
    @EnvironmentObject var locationManager: LocationManager
  
    @Environment(\.realm) var realm
    @ObservedResults(RealmCity.self) var cities
    @ObservedResults(RealmPlace.self) var places
    
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
          VStack {
            if let address = place?.location.formatted_address ??
                               places.first(where: { $0._id == placeId })?.formattedAddress {
              addressView(placeName: placeName, address: address)
            }
            ZStack() {
              if dataSource.placePhotos.isEmpty {
                apologizeView(with: "Unfortunately \nthis place can't provide \nany photos.")
                .frame(maxWidth: .infinity, alignment: .center)
              }
                GeometryReader { geo in
                  photoGrid(geo: geo)
              }
            }
          }
            VStack {
                Spacer()
                addToFavoriteButton()
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
        .task {
          dataSource.loadPlacePhotos(id: placeId)
          dataSource.loadPlaceTips(id: placeId)
          // Check if already saved
          checkIfAlreadySaved()
        }
      
        .sheet(isPresented: $showCarouselView) {
            FullScreenPhotoCarouselView(selectedIndex: $selectedPhotoIndex)
        }
        .sheet(isPresented: $showTips) {
            UsersTipsView(tips: dataSource.placeTips)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
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
  
  private func addressView(placeName: String, address: String) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(placeName)
          .font(.headline)
          .fontWeight(.bold)
          .lineLimit(1)
          .minimumScaleFactor(0.7)
        Text(address)
          .font(.subheadline)
          .foregroundColor(.gray)
          .fixedSize(horizontal: false, vertical: true)// перенос на несколько строк
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      Image(systemName: "mappin.and.ellipse") // можно заменить на mappin
        .foregroundColor(.red)
        .font(.title2)
        .padding(.trailing, 5)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(10) // ← внутренние отступы от текста до фона
    .background(Color.gray.opacity(0.2))
    .cornerRadius(8)
    .padding(.horizontal, 3)
    
  }
  
  // MARK: - Check if the place is already saved
  func checkIfAlreadySaved() {
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
  
  func toggleFavorite() {
    let city = findOrCreateCity(named: cityName)
    guard let city else { return }
    
    if let existingPlace = city.places.first(where: { $0._id == placeId }) {
      removePlace(existingPlace, from: city)
    } else if let place = place {
      addPlace(place, to: city)
    }
  }
  
  // MARK: - add place
  func addPlace(_ apiPlace: Place, to city: RealmCity) {
    let favoritePlace = RealmPlace(from: apiPlace)
    
    do {
      try realm.write {
        city.places.append(favoritePlace)
      }
      isAlreadySaved = true
    } catch {
      print("❌ Error adding place: \(error.localizedDescription)")
    }
  }
  
  // MARK: - remove place
  func removePlace(_ place: RealmPlace, from city: RealmCity) {
    do {
      try realm.write {
        if let index = city.places.firstIndex(of: place) {
          city.places.remove(at: index)
        }
        realm.delete(place)
      }
      isAlreadySaved = false
    } catch {
      print("❌ Error removing place: \(error.localizedDescription)")
    }
  }
  
  func findOrCreateCity(named name: String) -> RealmCity? {
    // ищем город
    if let existingCity = realm.objects(RealmCity.self).filter("name == %@", name).first {
      return existingCity
    }
    
    // если нет — создаём
    let newCity = RealmCity()
    newCity._id = UUID().uuidString
    newCity.name = name
    newCity.lat = locationManager.userLocation?.coordinate.latitude ?? 0
    newCity.lon = locationManager.userLocation?.coordinate.longitude ?? 0
    
    do {
      try realm.write {
        realm.add(newCity)
      }
      return newCity
    } catch {
      print("❌ Error creating city: \(error.localizedDescription)")
      return nil
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
      .disabled(dataSource.placeTips.isEmpty ? true : false)
      
      Menu {
        Text("Cell size")
        Button { columns = 3 } label: { Text("Small x3") }
        Button { columns = 2 } label: { Text("Medium x2") }
        Button { columns = 1 } label: { Text("Large x1") }
      } label: {
        Image(systemName: "eyeglasses")
      }
      .disabled(dataSource.placePhotos.isEmpty ? true : false)
      
    }
  }
}
