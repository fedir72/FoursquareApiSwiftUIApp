//
//  PlacePhotoView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 26.10.2022.
//

import SwiftUI

struct DetailPlaceView: View {
    
    let place: Place
    @State var photos: Photos = []
    @State var showTips = false
    
    @State var tips = [Tip]()
    @State var gridCounter: CGFloat = 3
    @State var grid = (1...3).map { _ in
        GridItem(.flexible(maximum: screen.width/3))
    }
        
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: grid, spacing: 5) {
                    ForEach(photos, id: \.id) { photoItem in
                        NavigationLink {
                            
                        } label: {
                            DetailGridCell(photoItem: photoItem)
                                .frame(
                                    width:screen.width/gridCounter - gridCounter,
                                    height: screen.width/gridCounter - gridCounter)
                        }
                    }
                }
            }
         
                    UsersTipsView(tips: tips)
                    .frame(height: tips.isEmpty ? 0 : screen.width )
                    .opacity(tips.isEmpty ? 0 : 1 )
                    .transition(.fade(duration: 0.2))
            
        }.edgesIgnoringSafeArea(.bottom)
    
        .onAppear {
            DataFetcher.shared.searchPlacePhotos(by: place.fsq_id ) { result in
                switch result {
                case .success(let responce):
                    self.photos = responce
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        .navigationTitle("Place photo")
        .toolbar {
            
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                            if tips.isEmpty {
                                DataFetcher.shared.getTips(by: place.fsq_id) { result in
                                    switch result {
                                    case .failure(let err):
                                        print(err.localizedDescription)
                                    case .success(let newtips):
                                        if newtips.isEmpty {
                                            print("there are not any user tips")
                                        } else {
                                            withAnimation {
                                                self.tips = newtips
                                                print(tips)
                                                
                                            }
                                        }
                                    }
                                }
                            } else {
                                withAnimation {
                                    self.tips = []
                                }
                            }
                        } label: {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    }
                }
        }
    }
}

struct DetailPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        DetailPlaceView(place:Place(fsq_id: "58bc8a1903cf257b09fad809", categories: [FoursquareAppSwiftUI.Category(id: 13347, name: "Tapas Restaurant", icon: FoursquareAppSwiftUI.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/tapas_", suffix: ".png")), FoursquareAppSwiftUI.Category(id: 13383, name: "Steakhouse", icon: FoursquareAppSwiftUI.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/steakhouse_", suffix: ".png"))], geocodes: FoursquareAppSwiftUI.Main(main: Optional(FoursquareAppSwiftUI.GeoPoint(latitude: Optional(28.122183), longitude: Optional(-16.724462)))), link: "/v3/places/58bc8a1903cf257b09fad809", location: FoursquareAppSwiftUI.Location(country: "ES", cross_street: Optional("principal"), formatted_address: Optional("Calle Grande, 9 (principal), 38670 Adeje Canary Islands")), name: "Restaurante el Puente", timezone: Optional("Atlantic/Canary")))
    }
}
