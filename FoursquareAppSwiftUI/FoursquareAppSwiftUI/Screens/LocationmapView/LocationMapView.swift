//
//  LocationMapView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 01.01.2023.
//


import SwiftUI
import MapKit
import SDWebImageSwiftUI
import RealmSwift



struct LocationMapView: View {
  
  
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var locationManager: LocationManager
  // @StateObject private var centerManager = MapCenterManager()
  
  @State private var region: MKCoordinateRegion
  @State private var selectedPlace: RealmPlace?
  
  @State private var debouncedCenter: EquatableLocation?
  @State private var updateTask: DispatchWorkItem?
  
  let realmCity: RealmCity
  let annotationItems: [RealmPlace]
  let isUserPosition: Bool
  
  init(realmCity: RealmCity, annotationItems: [RealmPlace], isUserPosition: Bool) {
    self.realmCity = realmCity
    self.annotationItems = annotationItems
    self.isUserPosition = isUserPosition
    
    if annotationItems.isEmpty {
      _region = State(initialValue: MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: realmCity.lat, longitude: realmCity.lon),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      ))
    } else {
      let lats = annotationItems.map { $0.lat }
      let lons = annotationItems.map { $0.lon }
      let minLat = lats.min()!
      let maxLat = lats.max()!
      let minLon = lons.min()!
      let maxLon = lons.max()!
      
      let centerLat = (minLat + maxLat) / 2
      let centerLon = (minLon + maxLon) / 2
      let latDelta = (maxLat - minLat) * 1.3
      let lonDelta = (maxLon - minLon) * 1.3
      
      _region = State(initialValue: MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
        span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
      ))
    }
  }
  
  var body: some View {
    ZStack {
      Map(coordinateRegion: $region,
          showsUserLocation: isUserPosition,
          annotationItems: annotationItems) { place in
        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon)) {
          Button {
            withAnimation(.spring()) {
              selectedPlace = place
            }
          } label: {
            customMapPin(with: place)
          }
        }
      }
          .edgesIgnoringSafeArea(.all)
          .onChange(of: EquatableLocation(coordinate: region.center)) { newCenter in
            updateTask?.cancel()
            let task = DispatchWorkItem {
              debouncedCenter = newCenter
              locationManager.updateAddress(for: newCenter.clLocationCoordinate2D)
            }
            updateTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: task)
          }
      
      // Центр карты
      Image(systemName: "plus")
        .font(.title)
        .foregroundColor(.orange)
        .shadow(color: .black.opacity(0.7), radius: 4)
      
      VStack {
        cityInfoHeader()
          .padding(.horizontal, 15)
          .padding(.top, 15)
        Spacer()
        if let selectedPlace = selectedPlace {
          MapPinActionsView(
            place: selectedPlace,
            cityId: realmCity._id,   // 👈 вместо целого объекта
            isUserPosition: isUserPosition,
            onClose: {
              withAnimation(.spring()) {
                self.selectedPlace = nil
              }
            }
          )
          .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        
      }
    }
  }
}

// MARK: - Private Methods
private extension LocationMapView {

    //MARK: - Top panel
    func cityInfoHeader() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(realmCity.name)
                    .font(.title.bold())
                    .foregroundStyle(.black)
                Text(locationManager.centerAddress)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let center = debouncedCenter {
                    Text("Map Center: \(center.latitude), \(center.longitude)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.title.bold())
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
    
    @ViewBuilder
    func customMapPin(with place: RealmPlace) -> some View {
        if let url = place.iconURL() {
            WebImage(url: url)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .background(Color("MapPinColor"))
                .foregroundColor(.white)
                .cornerRadius(20)
        } else {
            Image(systemName: "questionmark.circle.fill")
                .font(.title)
                .frame(width: 40, height: 40)
                .background(Color("MapPinColor"))
                .foregroundColor(.white)
                .cornerRadius(20)
        }
    }
}
