//
//  LocationView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 23.12.2022.
//

import SwiftUI

struct LocationRequestView: View {
  @EnvironmentObject var locationManager: LocationManager
 
  
    var body: some View {
        ZStack {
            Color(.systemBlue).edgesIgnoringSafeArea(.vertical)
            VStack {
                Spacer()
                VStack {
                    Image(systemName: "paperplane.circle.fill")
                        .resizedToFill(width: 150, height: 150)
                        .padding(.bottom, 20)
                    Text("would you like to explore places nearby")
                        .font(.system(size: 32, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("start sharing your location with us")
                        .font(.system(size: 22, design: .rounded))
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(.white)
               Spacer()
                VStack {
                    Button {
                      print("allow location?")
                       // LocationManager.requestLocation()
                    } label: {
                        Text("Allow location")
                        .font(.title3)
                    }
                    .frame(width: screen.width-100)
                    .padding(20)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
                    Button {
                        print("allow")
                    } label: {
                      Text("Maybe later")
                        .font(.title3)
                        .foregroundColor(.white)
                    }
                    
                }
                Spacer()
            }
            
            
        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
