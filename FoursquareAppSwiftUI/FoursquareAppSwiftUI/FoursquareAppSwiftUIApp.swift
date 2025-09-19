//
//  FoursquareAppSwiftUIApp.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import SwiftUI
import RealmSwift


let screen = UIScreen.main.bounds

@main
struct FoursquareAppSwiftUIApp: SwiftUI.App {
  
  @StateObject private var locationManager = LocationManager()
  @StateObject private var dataSource = PlacesDataSource(networkProvider: NetworkProvider())
  
  init() { CitySeeder.seedIfNeeded() }
  
  var body: some Scene {
        WindowGroup {
        //MainView()
          StartListView()
            .environmentObject(locationManager)
            .environmentObject(dataSource)
            .environment(\.realm, try! Realm())
            .onAppear {
                print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            }
        }
    }
}
