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
  
  @Environment(\.dismiss) var dismiss
  @State private var region: MKCoordinateRegion
  @State private var selectedPlace: Place? = nil

  let latitude: Double
  let longitude: Double
  let annotationitems: [Place]


  init(latitude: Double, longitude: Double, annotationitems: [Place]) {
    self.latitude = latitude
    self.longitude = longitude
    self.annotationitems = annotationitems

    // Если есть аннотации — масштабируем карту по ним
    if annotationitems.isEmpty {
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
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
    
    
    
    
//      self.latitude = latitude
//      self.longitude = longitude
//      self.annotationitems = annotationitems
//      
//      // Инициализируем регион на основе переданных координат
//      _region = State(initialValue: MKCoordinateRegion(
//          center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
//          span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//      ))
  }


    var body: some View {
      ZStack {
        VStack {
          HStack {
            Text("You are here now")
              .font(.title.bold())
              .foregroundColor(Color("MapPinColor"))
            Spacer()
            Button {
              dismiss()
            } label: {
              Image(systemName: "xmark.circle")
                .font(.title.bold())
            }
          }
          .padding()
          if annotationitems.isEmpty {
            Text("there are not any geopoints")
          }else{
            // ✅ ИЗМЕНЕНО: используем $region вместо .constant(region) для динамического центра карты
                               Map(coordinateRegion: $region,
                                   showsUserLocation: true,
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
                           }
                       }
            
//            Map(coordinateRegion: .constant(region),
//                showsUserLocation: true,
//                annotationItems: annotationitems) { place in
//              MapAnnotation(coordinate: place.location2D()) {
//                Button {
//                  print("pin")
//                  withAnimation { selectedPlace = place }
//                } label: {
//                  customMapPin(with: place)
//                }
//              }
//            }
//          }
//        }
//        .edgesIgnoringSafeArea(.bottom)
        
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
      .onAppear {
        print( annotationitems.count,"annotations" )
        }
    }
  
  
}

 extension View {
  
   func mapPinStyle() -> some View {
        self.modifier(MapPinStyle())
    }
  
  @ViewBuilder
  func customMapPin(with place: Place) -> some View {
      if let category = place.categories.first,
         let url = category.icon.iconURl(resolution: .micro) {
          AnimatedImage(url: url)
              .resizable()
              .scaledToFit()
              .mapPinStyle()
      } else {
          Image(systemName: "questionmark.circle.fill")
              .font(.title)
              .mapPinStyle()
      }
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
}


struct MapPinStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 40, height: 40)
            .background(Color("MapPinColor"))
            .foregroundColor(.white)
            .cornerRadius(20)
    }
}



