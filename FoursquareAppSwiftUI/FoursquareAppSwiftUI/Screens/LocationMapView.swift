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
    
    var body: some View {
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
                        VStack {
                            AnimatedImage(url: place.categories[0].icon.iconURl(resolution: .micro))
                                .font(.title)
                                .frame(width: 40,height: 40)
                                .background(Color("MapPinColor"))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

//struct LocationMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationMapView(showMap: .constant(true),
//                        region: .constant
//                        (MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 37.331516,
//                                           longitude: -121.891054),
//            span: MKCoordinateSpan(latitudeDelta: 0.05,
//                                   longitudeDelta: 0.05))),
//            annotationitems: .constant([]))
//    }
//}
