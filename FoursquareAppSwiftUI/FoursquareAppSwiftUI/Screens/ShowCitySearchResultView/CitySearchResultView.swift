//
//  ShowCitySearchResultView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 01.09.25.
//

import SwiftUI
import RealmSwift

struct CitySearchResultView: View {
  //MARK: - propertys
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var dataSource: PlacesDataSource
  
  let searchCityTerm: String
  
  var body: some View {
   Form {
      if dataSource.cities.isEmpty {
        Text("Cities not found")
          .font(.largeTitle)
          .foregroundStyle(.red)
      } else {
        List(dataSource.cities) { city in
          Button {
            saveCityToRealm(RealmCity(from: city))
            dismiss()
          } label: {
            CityRow(city: city)
          }
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
        print("error adding new item: \(error)")
    }
  }
  
}

#Preview {
  CitySearchResultView(searchCityTerm: "Tkyo")
}
