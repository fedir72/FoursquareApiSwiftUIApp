//
//  ShowCitySearchResultView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 01.09.25.
//

import SwiftUI
import RealmSwift

struct ShowCitySearchResultView: View {
  //MARK: - propertys
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var dataSource: PlacesDataSource
  
  let searchCityTerm: String
  
  var body: some View {
    VStack {
      if dataSource.cities.isEmpty {
        Text("data not found")
      }
        List(dataSource.cities) { city in
          Button {
           saveCityToRealm(RealmCity(from: city))
            dismiss()
          } label: {
            CityRow(city: city)
          }
      }
    }
    .task {
      dataSource.loadCities(by: searchCityTerm, limit: 15 )
    }
  }
  
  private func saveCityToRealm(_ city: RealmCity ) {
    do {
        let realm = try Realm()
        if !city.isInvalidated {
            try realm.write {
              realm.add(city)
            }
        }
    } catch {
        print("Ошибка при удалении: \(error)")
    }
  }
  
}

#Preview {
  ShowCitySearchResultView(searchCityTerm: "Tokyo")
}
