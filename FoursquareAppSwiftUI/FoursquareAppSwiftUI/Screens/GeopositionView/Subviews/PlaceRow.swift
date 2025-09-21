//
//  PlaceRow.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 19.09.25.
//

import SwiftUI


struct PlaceRow: View {
  let realmPlace: RealmPlace
  
  // MARK: - Init from Place
  init(place: Place) {
    self.realmPlace = RealmPlace(from: place)
  }
  
  // MARK: - Init from RealmPlace
  init(realmPlace: RealmPlace) {
    self.realmPlace = realmPlace
  }
  
  var body: some View {
    HStack() {
      VStack(alignment: .leading, spacing: 1) {
        Text(realmPlace.name)
          .font(.headline)
          .foregroundColor(.blue)
        Text(realmPlace.categoryName ?? "category not found")
          .font(.body)
          .foregroundColor(.gray)
      }
      Spacer()
      CategoryPlaceImage(url: realmPlace.iconURL())
    }
    .padding(.horizontal, 5)
    .padding(.vertical, 6)
  }
}




