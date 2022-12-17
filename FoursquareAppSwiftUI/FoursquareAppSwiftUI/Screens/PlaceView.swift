//
//  ContentView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import SwiftUI
//import Combine

struct PlaceView: View {
    
    @State var places = [Place]()
    @Binding var showCategories: Bool
    @Binding var searchCategoryIndex: Int
    
    var body: some View {
        NavigationView {
            List {
                if places.isEmpty {
                    Text("Did not found any places")
                        .font(.title)
                        .foregroundColor(.red)
                }
                        ForEach(places,id: \.name) { place in
                            SearchCellView(place: place)
                                .onTapGesture {
                                    
                          }
                       }
                }
               .listStyle(.plain)
            
            .onAppear {
                Foursquare.shared.getNearestPlaces(
                    term: nil,
                    category: nil,
                    lat: 28.1227,
                    long: -16.7260) { result in
                        switch result {
                            
                        case .success(let places):
                            self.places = places.results
                        case .failure(let error):
                            print(error)
                        }
                    }
            }
            
            .navigationTitle("Nearest places")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("leading")
                        showCategories.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("trailing")
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(showCategories: .constant(false),
                  searchCategoryIndex: .constant(0))
    }
}
