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

    @Binding var showMap: Bool
    let region: MKCoordinateRegion
    let annotationitems: [Place]
    @State private var selectedPlace: Place? = nil

    var body: some View {
      ZStack {
        VStack {
          HStack {
            Text("You are here now")
              .font(.title.bold())
              .foregroundColor(Color("MapPinColor"))
            Spacer()
            Button {
              showMap.toggle()
            } label: {
              Image(systemName: "xmark.circle")
                .font(.title.bold())
            }
          }
          .padding()
          if annotationitems.isEmpty {
            Text("there are not any geopoints")
          }else{
            Map(coordinateRegion: .constant(region),
                showsUserLocation: true,
                annotationItems: annotationitems) { place in
              MapAnnotation(coordinate: place.location2D()) {
                Button {
                  print("pin")
                  withAnimation { selectedPlace = place }
                } label: {
                  customMapPin(with: place)
                }
              }
            }
          }
        }
        .edgesIgnoringSafeArea(.bottom)
        
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



