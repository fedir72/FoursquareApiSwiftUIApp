//
//  ContentView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import SwiftUI
import UIKit
import MapKit

struct GeopointView: View {
    @State var showMap = false
    @State var firstAppearance = true
    @State var places = [Place]() {
        didSet { print("places",places.count) }
            
        }
    
    @State var searchTerm: String = ""
    @Binding var showCategories: Bool
    @Binding var searchCategoryIndex: Int
    @ObservedObject var locationManager = LocationManager.shares
    
    
    var body: some View {
        
        
        NavigationView {
            VStack {
                VStack {
                    Text("places; \(places.count)")
                    Text("index: \(searchCategoryIndex)")
                    Text("term: \(searchTerm)")
                }
                List {
                    
                    if places.isEmpty {
                        Text("Did not found any places")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    ForEach(places,id: \.name) { place in
                        NavigationLink(destination: DetailPlaceView(place: place)) {
                            SearchCellView(place: place)
                        }
                    }
                }
                .listStyle(.grouped)
                .onChange(of: searchTerm){ newTerm in
                    searchPlaces(term: newTerm,
                                 category: nil)
                }
                .onChange(of: searchCategoryIndex, perform: { newIndex in
                    searchPlaces(term: nil,
                                 category: String(newIndex))
                })
            }
            .onAppear {
                if firstAppearance {
                    searchPlaces(term: nil, category: nil)
                    self.firstAppearance = false
                }
            }
            .sheet(isPresented: $showMap) {
                    LocationMapView(showMap: $showMap,
                                    region: locationManager.region,
                                    annotationitems: places )
                }
            .navigationTitle("Nearest places")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showCategories.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("show map")
                        showMap.toggle()
                    } label: {
                        Image(systemName: "globe")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSearchAlert()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            
        }
    }
}

struct GeopointView_Previews: PreviewProvider {
    static var previews: some View {
        GeopointView(showCategories: .constant(false),
                  searchCategoryIndex: .constant(0))
    }
}

extension GeopointView {
   
    func searchPlaces(term: String?,
                      category: String?) {
        DataFetcher.shared.getNearestPlaces(
            term: term,
            category: category,
            lat: locationManager.userLocation?.coordinate.latitude ?? 0,
            long: locationManager.userLocation?.coordinate.longitude ?? 0) { result in
                switch result {
                case .success(let places):
                    self.places = places.results
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func showSearchAlert() {
       let alert = UIAlertController(title: "Enter approximate search term",
                                     message: nil,
                                     preferredStyle: .alert)
        alert.addTextField {  $0.placeholder = "search term" }
        alert.addAction(.init(title: "cancel", style: .destructive))
        alert.addAction(.init(title: "search", style: .default) { _ in
            guard let term = alert.textFields?.first!.text,
                  !term.isEmpty else { return }
            self.searchTerm = term
            print(searchTerm)
        })
        rootController().present(alert, animated: true)
    }
    
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first
                           as? UIWindowScene else { return .init() }
        guard let root = screen.windows.first?.rootViewController
                         else { return .init() }
        return root
    }
}
