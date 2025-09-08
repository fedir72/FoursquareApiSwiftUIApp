//
//  CtyRow.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 08.09.25.
//

import SwiftUI

struct CityRow: View {
  let city: CityRepresentable
  
  var body: some View {
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
