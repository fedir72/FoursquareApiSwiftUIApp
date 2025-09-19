//
//  CtyRow.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 08.09.25.
//

import SwiftUI
import RealmSwift

struct CityRow: View {
  let city: RealmCity
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {

      Text(city.fullAddress)
        .font(.headline)
        .foregroundColor(.blue)
      if city.places.isEmpty == false {
        Text("favorites: \(city.places.count)")
                .font(.subheadline)
                .foregroundStyle(.red)
      }
      Text(city.coordinateText)
        .font(.subheadline)
        .foregroundColor(.gray)
    }
    .padding(.vertical, 6)
  }
}
