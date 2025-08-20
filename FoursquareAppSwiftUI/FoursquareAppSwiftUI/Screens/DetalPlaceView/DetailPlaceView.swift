//
//  PlacePhotoView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 26.10.2022.
//

import SwiftUI

struct DetailPlaceView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var dataSource: PlacesDataSource
    
    @State var place: Place
    @State private var showTips = false
    @AppStorage("columns") private var columns: Int = 3
  
    func columns(size: CGSize, countColumn: CGFloat) -> [GridItem] {
        [ GridItem(.adaptive( minimum:
        Settings.thumbnailSize(size: size,countColumns: countColumn).width
        ))]
    }

    var body: some View {
        GeometryReader { geo in
          ScrollView(.vertical) {
            LazyVGrid(
              columns:columns(size: geo.size, countColumn:CGFloat(columns)),
              spacing: 3
                     ) {
                 ForEach(dataSource.placePhotos, id: \.id) { photoItem in
                 NavigationLink {
                                //show the photo
                   } label: {
                        DetailGridCell(photoItem: photoItem)
                           .shadow(color: .black,radius: 2, x: 2, y: 2)
                            }
                        }
                    }
                }
            .edgesIgnoringSafeArea(.bottom)
            .task {
              dataSource.loadPlacePhotos(id: place.id)
              dataSource.loadPlaceTips(id: place.id)
                }
        }
        .sheet(isPresented: $showTips) {
          UsersTipsView(tips: dataSource.placeTips)
          }
        .navigationTitle(place.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              
              Button {
                  showTips.toggle()
                } label: {
                  Text("Tips(\(dataSource.placeTips.count))") .bold()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
              Menu {
                    Text("Cell size")
                    Button { columns = 3 } label: { Text("Small x3") }
                    Button { columns = 2 } label: { Text("Medium x2") }
                    Button { columns = 1 } label: { Text("Large x1") }
                } label: {
                    Image(systemName: "eyeglasses")
                }
            }
        }
    }
}

struct DetailPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        DetailPlaceView(place:Place(id: "58bc8a1903cf257b09fad809", categories: [FoursquareAppSwiftUI.Category(id: 13347, name: "Tapas Restaurant", icon: FoursquareAppSwiftUI.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/tapas_", suffix: ".png")), FoursquareAppSwiftUI.Category(id: 13383, name: "Steakhouse", icon: FoursquareAppSwiftUI.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/steakhouse_", suffix: ".png"))], geocodes: FoursquareAppSwiftUI.Main(main: Optional(FoursquareAppSwiftUI.GeoPoint(latitude: Optional(28.122183), longitude: Optional(-16.724462)))), link: "/v3/places/58bc8a1903cf257b09fad809", location: FoursquareAppSwiftUI.MapAdress(country: "ES", cross_street: Optional("principal"), formatted_address: Optional("Calle Grande, 9 (principal), 38670 Adeje Canary Islands")), name: "Restaurante el Puente", timezone: Optional("Atlantic/Canary")))
    }
}
