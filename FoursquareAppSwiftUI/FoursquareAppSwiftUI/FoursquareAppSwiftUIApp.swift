//
//  FoursquareAppSwiftUIApp.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import SwiftUI


let screen = UIScreen.main.bounds

@main
struct FoursquareAppSwiftUIApp: App {
  @StateObject private var locationManager = LocationManager()
  @StateObject private var dataSource = PlacesDataSource(networkProvider: NetworkProvider())
  
  var body: some Scene {
        WindowGroup {
            MainView()
            .environmentObject(locationManager)
            .environmentObject(dataSource)
            
        }
    }
}
