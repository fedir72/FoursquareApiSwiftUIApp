//
//  ContentView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import SwiftUI
import UIKit
//import Combine

struct GeopointView: View {
    
    @State var places = [Place]()
    @State var searchTerm: String = ""
    @Binding var showCategories: Bool
    @Binding var searchCategoryIndex: Int
    
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
                                category: nil,
                                lat: 28.1227, lon: -16.7260)
               }
               .onChange(of: searchCategoryIndex, perform: { newIndex in
                   searchPlaces(term: nil,
                                category: String(newIndex),
                                lat: 28.1227, lon: -16.7260)
               })
              .onAppear {
                   searchPlaces(term: nil,
                             category: nil,
                             lat: 28.1227, lon: -16.7260)
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
                      showSearchAlert()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
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
                      category: String?,
                      lat: Double,
                      lon: Double) {
        Foursquare.shared.getNearestPlaces(
            term: term,
            category: category,
            lat: lat,
            long: lon) { result in
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
