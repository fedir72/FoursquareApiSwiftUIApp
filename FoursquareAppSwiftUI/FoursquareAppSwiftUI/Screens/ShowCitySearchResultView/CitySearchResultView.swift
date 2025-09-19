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
  @Environment(\.realm) var realm
  
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
            openMapCityRow(city)
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
            try realm.write {
              realm.add(city)
            }
    } catch {
        print("error adding new item: \(error)")
    }
  }
  
  private func openMapCityRow(_ city: OpenMapCity) -> some View {
    
      VStack(alignment: .leading, spacing: 4) {
        Text(city.name)
          .font(.headline)
          .foregroundStyle(.blue)
        Text(city.fullAddress)
          .font(.subheadline)
          .foregroundColor(.gray)
        Text(city.coordinateText)
          .font(.subheadline)
          .foregroundColor(.gray)
      }
      .padding(.vertical, 6)
    }
  
}

#Preview {
  CitySearchResultView(searchCityTerm: "Tkyo")
}
