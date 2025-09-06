//
//  SearchCellView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import SwiftUI

struct SearchRow: View {
    
    var place: Place
    
    var body: some View {
            HStack {
                VStack(alignment: .leading){
                    Text(place.name)
                        .font(.title2)
                        .lineLimit(1)
                    Text(place.categories.first?.name ?? "category not found")
                        .font(.system(size: 15))
                        .foregroundColor(Color(cgColor: UIColor.systemGray.cgColor))
                }
                .minimumScaleFactor(0.3)
                Spacer()
                CategoryPlaceImage(
                url:place.categories.first?.icon.iconURl(resolution: .small))
            }
            .padding(.horizontal,5)
    }
}

struct SearchCellView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRow(place:
                        Place(id: "58bc8a1903cf257b09fad809", categories: [FoursquareAppSwiftUI.Category(id: 13347, name: "Tapas Restaurant", icon: FoursquareAppSwiftUI.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/tapas_", suffix: ".png")), FoursquareAppSwiftUI.Category(id: 13383, name: "Steakhouse", icon: FoursquareAppSwiftUI.Icon(prefix: "https://ss3.4sqi.net/img/categories_v2/food/steakhouse_", suffix: ".png"))], geocodes: FoursquareAppSwiftUI.Main(main: Optional(FoursquareAppSwiftUI.GeoPoint(latitude: Optional(28.122183), longitude: Optional(-16.724462)))), link: "/v3/places/58bc8a1903cf257b09fad809", location: FoursquareAppSwiftUI.MapAdress(country: "ES", cross_street: Optional("principal"), formatted_address: Optional("Calle Grande, 9 (principal), 38670 Adeje Canary Islands")), name: "Restaurante el Puente", timezone: Optional("Atlantic/Canary")))
        .previewLayout(.sizeThatFits)
    }
}
