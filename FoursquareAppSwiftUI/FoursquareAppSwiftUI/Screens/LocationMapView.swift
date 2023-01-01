//
//  LocationMapView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 01.01.2023.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @Binding var showMap: Bool
    @Binding var region: MKCoordinateRegion
    var body: some View {
        VStack {
            HStack {
                Text("You are here now")
                    .font(.title.bold())
                    .foregroundColor(.purple)
                    Spacer()
                Button {
                    showMap.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.title.bold())
                }
            }
            .padding()
            
            Map(coordinateRegion: $region ,
                     showsUserLocation: true)
            
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView(showMap: .constant(true),
                        region: .constant(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.331516,
                                           longitude: -121.891054),
            span: MKCoordinateSpan(latitudeDelta: 0.05,
                                   longitudeDelta: 0.05))))
    }
}
