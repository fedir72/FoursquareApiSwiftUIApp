//
//  ContentView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import SwiftUI
import MapKit

struct GeopointView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var dataSource: PlacesDataSource
    
    @State private var showMap = false
    @State private var searchTerm: String = ""
    @State private var showSearchAlert = false
    @State private var tempSearchTerm = ""
    
    @Binding var showCategories: Bool
    @Binding var searchCategoryIndex: Int
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("places: \(dataSource.nearbyPlaces.count)")
                    Text("index: \(searchCategoryIndex)")
                    Text("term: \(searchTerm)")
                }
                List {
                    if dataSource.nearbyPlaces.isEmpty {
                        Text("Did not find any places")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    
                    ForEach(dataSource.nearbyPlaces, id: \.name) { place in
                        NavigationLink(destination: DetailPlaceView(place: place)) {
                            SearchCellView(place: place)
                        }
                    }
                }
                .listStyle(.grouped)
                .onChange(of: locationManager.userLocation) { _ in
                    loadNearbyPlaces()
                }
                .onChange(of: searchTerm) { _ in
                    getPlaces(term: searchTerm)
                }
                .onChange(of: searchCategoryIndex) { _ in
                    getPlaces(category: String(searchCategoryIndex))
                }
                .sheet(isPresented: $showMap) {
                    LocationMapView(
                        showMap: $showMap,
                        region: locationManager.region,
                        annotationitems: dataSource.nearbyPlaces
                    )
                }
            }
            .navigationTitle("Nearest Places")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showCategories.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showMap.toggle()
                    } label: {
                        Image(systemName: "globe")
                    }
                    
                    Button {
                        tempSearchTerm = searchTerm
                        showSearchAlert = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .alert("Enter approximate search term", isPresented: $showSearchAlert, actions: {
                TextField("search term", text: $tempSearchTerm)
                Button("Search") { searchTerm = tempSearchTerm }
                Button("Cancel", role: .cancel) {
                  tempSearchTerm = ""
                }
            })
            .onAppear {
                loadNearbyPlaces()
            }
        }
    }
    
    // MARK: - Helper Methods
    private func loadNearbyPlaces() {
        guard let location = locationManager.userLocation else { return }
        dataSource.loadNearbyPlaces(
            lat: location.coordinate.latitude,
            long: location.coordinate.longitude
        )
    }
    
    private func getPlaces(term: String? = nil, category: String? = nil) {
        guard let location = locationManager.userLocation else { return }
        dataSource.getPlaces(
            term: term,
            category: category,
            lat: location.coordinate.latitude,
            long: location.coordinate.longitude
        )
    }
}

struct GeopointView_Previews: PreviewProvider {
    static var previews: some View {
        GeopointView(
            showCategories: .constant(false),
            searchCategoryIndex: .constant(0)
        )
        .environmentObject(LocationManager())
        .environmentObject(PlacesDataSource(networkProvider: NetworkProvider()))
    }
}








//import SwiftUI
//import UIKit
//import MapKit
//
//struct GeopointView: View {
//  
//    @EnvironmentObject var locationManager: LocationManager
//    @EnvironmentObject var dataSource: PlacesDataSource
//  
//    @State var showMap = false
//    @State var firstAppearance = true
////    @State var places = [Place]() {
////        didSet { print("places",places.count) }
////        }
//    
//    @State var searchTerm: String = ""
//    @Binding var showCategories: Bool
//    @Binding var searchCategoryIndex: Int
//   
//  
//  
//    var body: some View {
//        NavigationView {
//            VStack {
//                VStack {
//                  Text("places; \(dataSource.nearbyPlaces.count)")
//                    Text("index: \(searchCategoryIndex)")
//                    Text("term: \(searchTerm)")
//                }
//                List {
//                    
//                    if dataSource.nearbyPlaces.isEmpty {
//                        Text("Did not found any places")
//                            .font(.title)
//                            .foregroundColor(.red)
//                    }
//                  
//                  ForEach(dataSource.nearbyPlaces,id: \.name) { place in
//                        NavigationLink(destination: DetailPlaceView(place: place)) {
//                            SearchCellView(place: place)
//                        }
//                    }
//                }
//                .listStyle(.grouped)
//                .onChange(of: locationManager.userLocation) {
//                  dataSource.loadNearbyPlaces(lat: locationManager.userLocation?.coordinate.latitude ?? 0,                                               long: locationManager.userLocation?.coordinate.longitude ?? 0)
//                }
//                .onChange(of: searchTerm){ newTerm in
//                  dataSource.getPlaces(term: searchTerm,
//                                       category: nil,
//                                       lat: locationManager.userLocation?.coordinate.latitude ?? 0,
//                                       long: locationManager.userLocation?.coordinate.longitude ?? 0)
//                }
//                .onChange(of: searchCategoryIndex, perform: { newIndex in
//                dataSource.getPlaces(term: nil,
//                                     category: String(searchCategoryIndex),
//                                     lat: locationManager.userLocation?.coordinate.latitude ?? 0,
//                                     long: locationManager.userLocation?.coordinate.longitude ?? 0)
//                })
//              
//                .sheet(isPresented: $showMap) {
//                        LocationMapView(showMap: $showMap,
//                                        region: locationManager.region,
//                                        annotationitems: dataSource.nearbyPlaces)
//                    }
//
//            }
////            .onChange(of: locationManager.userLocation) {
////              dataSource.loadNearbyPlaces(lat: locationManager.userLocation?.coordinate.latitude ?? 0,                                               long: locationManager.userLocation?.coordinate.longitude ?? 0)
////            }
////            .onChange(of: searchTerm){ newTerm in
////              dataSource.getPlaces(term: searchTerm,
////                                   category: nil,
////                                   lat: locationManager.userLocation?.coordinate.latitude ?? 0,
////                                   long: locationManager.userLocation?.coordinate.longitude ?? 0)
////            }
////            .onChange(of: searchCategoryIndex, perform: { newIndex in
////            dataSource.getPlaces(term: nil,
////                                 category: String(searchCategoryIndex),
////                                 lat: locationManager.userLocation?.coordinate.latitude ?? 0,
////                                 long: locationManager.userLocation?.coordinate.longitude ?? 0)
////            })
////          
////            .sheet(isPresented: $showMap) {
////                    LocationMapView(showMap: $showMap,
////                                    region: locationManager.region,
////                                    annotationitems: dataSource.nearbyPlaces)
////                }
//            //.navigationTitle("Nearest places")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        showCategories.toggle()
//                    } label: {
//                        Image(systemName: "list.bullet")
//                    }
//                }
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                  Button {
//                    print("show map")
//                    showMap.toggle()
//                  } label: {
//                      Image(systemName: "globe")
//                    }
//                   Button {
//                          showSearchAlert()
//                      } label: {
//                          Image(systemName: "magnifyingglass")
//                      }
//                      
//                    }
//               }
//            }
//        }
//    }
//
//
//struct GeopointView_Previews: PreviewProvider {
//    static var previews: some View {
//        GeopointView(showCategories: .constant(false),
//                  searchCategoryIndex: .constant(0))
//    }
//}
//
//extension GeopointView {
//    
//    func showSearchAlert() {
//       let alert = UIAlertController(title: "Enter approximate search term",
//                                     message: nil,
//                                     preferredStyle: .alert)
//        alert.addTextField {  $0.placeholder = "search term" }
//        alert.addAction(.init(title: "cancel", style: .destructive))
//        alert.addAction(.init(title: "search", style: .default) { _ in
//            guard let term = alert.textFields?.first!.text,
//                  !term.isEmpty else { return }
//            self.searchTerm = term
//            print(searchTerm)
//        })
//        rootController().present(alert, animated: true)
//    }
//    
//    func rootController() -> UIViewController {
//        guard let screen = UIApplication.shared.connectedScenes.first
//                           as? UIWindowScene else { return .init() }
//        guard let root = screen.windows.first?.rootViewController
//                         else { return .init() }
//        return root
//    }
//}
