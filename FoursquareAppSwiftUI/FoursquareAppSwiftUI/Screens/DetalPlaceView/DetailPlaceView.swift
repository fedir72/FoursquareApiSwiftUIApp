//
//  PlacePhotoView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 26.10.2022.
//


import SwiftUI
import SDWebImageSwiftUI
import SDWebImage





struct DetailPlaceView: View {
  
  //MARK: - properties
  @EnvironmentObject var locationManager: LocationManager
  @EnvironmentObject var dataSource: PlacesDataSource
  
  @State var place: Place
  @State  private var selectedPhotoIndex = 0 {
    didSet { print( "index", selectedPhotoIndex ) }
  }
  @State private var showCarouselView = false
  @State private var showTips = false
  @AppStorage("countColumns") private var columns: Int = 3
  
  //MARK: - padding and distance between cells calculation function
  func columns(size: CGSize,
               countColumn: Int,
               spacing: CGFloat = 3,
               edgePadding: CGFloat = 3) -> [GridItem] {
    //MARK: - общая ширина, доступная для всех ячеек с учётом внешних отступов и промежутков
    let totalSpacing = spacing * CGFloat(countColumn - 1) + edgePadding * 2
    let itemWidth = (size.width - totalSpacing) / CGFloat(countColumn)
    return Array(repeating: GridItem(.fixed(itemWidth),
                                     spacing: spacing),
                 count: countColumn )
  }
  
  //MARK: - body
  var body: some View {
    GeometryReader { geo in
      ScrollView(.vertical,showsIndicators: false) {
        LazyVGrid( columns:columns(size: geo.size,
                                   countColumn: columns),
                   spacing: 3 ) {
          ForEach(dataSource.placePhotos) { photoItem in
            
            Button {
              if let ind = dataSource.placePhotos.firstIndex(of: photoItem) {
                selectedPhotoIndex = ind
                showCarouselView.toggle()
                
              }
            } label: {
              DetailGridCell(photoItem: photoItem)
            }
          }
        }
      }
      .task {
        dataSource.loadPlacePhotos(id: place.id)
        dataSource.loadPlaceTips(id: place.id)
      }
    }
    .sheet(isPresented: $showCarouselView ) {
      FullScreenPhotoCarouselView(selectedIndex: selectedPhotoIndex)
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



//struct DetailPlaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailPlaceView(place:Place(id: "58bc8a1903cf257b09fad809", categories: [FoursquareAppSwiftUI.Category(id: 13347, name: "Tapas Restaurant", icon: FoursquareAppSwiftUI.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/tapas_", suffix: ".png")), FoursquareAppSwiftUI.Category(id: 13383, name: "Steakhouse", icon: FoursquareAppSwiftUI.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/steakhouse_", suffix: ".png"))], geocodes: FoursquareAppSwiftUI.Main(main: Optional(FoursquareAppSwiftUI.GeoPoint(latitude: Optional(28.122183), longitude: Optional(-16.724462)))), link: "/v3/places/58bc8a1903cf257b09fad809", location: FoursquareAppSwiftUI.MapAdress(country: "ES", cross_street: Optional("principal"), formatted_address: Optional("Calle Grande, 9 (principal), 38670 Adeje Canary Islands")), name: "Restaurante el Puente", timezone: Optional("Atlantic/Canary")))
//    }
//}
