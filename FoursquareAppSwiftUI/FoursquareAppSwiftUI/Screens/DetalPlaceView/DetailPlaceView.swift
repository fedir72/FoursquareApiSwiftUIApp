//
//  PlacePhotoView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 26.10.2022.
//

import SwiftUI

struct DetailPlaceView: View {
    
    var place: Place
    @State private var photos: Photos = []
    @State private var showTips = false
    @State private var tips = [Tip]()
    @State private var columns: CGFloat = 3
    
    func columns(size: CGSize, countColumn: CGFloat) -> [GridItem] {
        [ GridItem(.adaptive(
            minimum:
        Settings.thumbnailSize(size: size,
                       countColumns: countColumn).width
        ))]
            
    }
        
    var body: some View {
        GeometryReader { geo in
            VStack {
                ScrollView(.vertical) {
                    LazyVGrid(columns:
                    columns(size: geo.size, countColumn: columns),
                            spacing: 5) {
                        ForEach(photos, id: \.id) { photoItem in
                            NavigationLink {
                                
                            } label: {
                                DetailGridCell(photoItem: photoItem)
                                   // .shadow(radius: 3,x: 3, y: 3)
                            }
                        }
                    }
                    .opacity($tips.isEmpty ? 1 : 0.3)
                    .transition(.fade(duration: 0.2))
                }
                .frame(width: geo.size.width)
                UsersTipsView(tips: $tips)
                    .frame(height: tips.isEmpty ? 0 : screen.height*0.6 )
                    .opacity(tips.isEmpty ? 0 : 1 )
                    .transition(.fade(duration: 0.2))
            }
            .edgesIgnoringSafeArea(.bottom)
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
        }
        .navigationTitle( place.name)
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
                    Text("TIPS")
                        .bold()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button { columns = 3 } label: {
                        Text("Small x3")
                    }
                    Button { columns = 2 } label: {
                        Text("Medium x2")
                        
                    }
                    Button { columns = 1 } label: {
                        Text("Large x1")
                    }

                } label: {
                    Image(systemName: "eyeglasses")
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
