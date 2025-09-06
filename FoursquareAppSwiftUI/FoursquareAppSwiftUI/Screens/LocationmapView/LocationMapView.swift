//
//  LocationMapView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 01.01.2023.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI

struct LocationMapView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var locationManager: LocationManager
  
    @State private var region: MKCoordinateRegion
    @State private var selectedPlace: Place? = nil
  
    //MARK: - change mapcenter items (scroll)
    @State private var debouncedCenter: EquatableLocation? = nil
    @State private var updateTask: DispatchWorkItem? = nil
  
    
    let realmCity: RealmCity
    let annotationitems: [Place]
    
    init(realmCity: RealmCity, annotationitems: [Place]) {
        self.realmCity = realmCity
        self.annotationitems = annotationitems
        
        // Масштаб карты
        if annotationitems.isEmpty {
            _region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: realmCity.lat, longitude: realmCity.lon),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        } else {
            let lats = annotationitems.map { $0.location2D().latitude }
            let lons = annotationitems.map { $0.location2D().longitude }
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
          ZStack {
            // MARK: — Карта с Place-аннотациями
            Map(coordinateRegion: $region,
                showsUserLocation: false,
                annotationItems: annotationitems) { place in
              MapAnnotation(coordinate: place.location2D()) {
                Button {
                  withAnimation { selectedPlace = place }
                } label: {
                  customMapPin(with: place)
                }
              }
            }
                .edgesIgnoringSafeArea(.all)
            //MARK: - tracking the center of the map
                .onChange(of: EquatableLocation(coordinate: region.center)) { newCenter in
                  // undo previous task
                  updateTask?.cancel()
                  
                  // update new task with half a second delay
                  let task = DispatchWorkItem {
                    debouncedCenter = newCenter
                    locationManager.updateAddress(for: newCenter.clLocationCoordinate2D)
                    print("did scroll to:", newCenter.latitude, newCenter.longitude)
                  }
                  updateTask = task
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
                }
            
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(.blue)
                .shadow(radius: 4)
            
          }
            
            VStack {
              cityInfoHeader()
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                Spacer()
                
                // MARK: — Детали выбранного Place
                if let place = selectedPlace {
                    VStack {
                        Spacer()
                        PlaceDetailView(place: place) {
                            withAnimation { selectedPlace = nil }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding()
        }
        .onAppear {
            print(annotationitems.count, "Place annotations")
        }
    }
  
  //MARK: — Top panel cityname, coordinates and address
   fileprivate func cityInfoHeader() -> some View {
    HStack {
      VStack(alignment: .leading) {
        Text(realmCity.name)
          .font(.title.bold())
          .foregroundStyle(.black)
        Text(locationManager.centerAddress)
          .font(.subheadline)
          .foregroundStyle(.secondary)
        //MARK: - dynamic display of map center coordinates
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
  }
  
    
    // MARK: — Кастомная Map-пин функция
    @ViewBuilder
    func customMapPin(with place: Place) -> some View {
        if let category = place.categories.first,
           let url = category.icon.iconURl(resolution: .micro) {
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

// MARK: — PlaceDetailView
struct PlaceDetailView: View {
    let place: Place
    let onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(place.name)
                .font(.headline)
            Text(place.categories.first?.name ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button {
                openInMaps(place: place)
            } label: {
                Label("Open in Maps", systemImage: "map")
                    .font(.callout.bold())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            
            Button(action: onClose) {
                Label("Close", systemImage: "xmark.circle")
                    .font(.callout.bold())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
    
    func openInMaps(place: Place) {
        let coordinate = place.location2D()
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

  

