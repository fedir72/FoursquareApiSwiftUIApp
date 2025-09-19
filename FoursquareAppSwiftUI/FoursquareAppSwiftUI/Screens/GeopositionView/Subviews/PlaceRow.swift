//
//  PlaceRow.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 19.09.25.
//

import SwiftUI

struct PlaceRow: View {
    private let name: String
    private let categoryName: String
    private let categoryIconURL: URL?
    
    // MARK: - Init from Foursquare Place
    init(place: Place) {
        self.name = place.name
        self.categoryName = place.categories.first?.name ?? "category not found"
        self.categoryIconURL = place.categories.first?.icon.iconURl(resolution: .small)
    }
    
    // MARK: - Init from RealmPlace
    init(realmPlace: RealmPlace) {
        self.name = realmPlace.name
        self.categoryName = realmPlace.categoryName ?? "category not found"
        if let prefix = realmPlace.categoryIconPrefix, let suffix = realmPlace.categoryIconSuffix {
            self.categoryIconURL = URL(string: "\(prefix)44\(suffix)")
        } else {
            self.categoryIconURL = nil
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title2)
                    .lineLimit(1)
                    .foregroundStyle(.blue)
                Text(categoryName)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
            }
            .minimumScaleFactor(0.3)
            Spacer()
            CategoryPlaceImage(url: categoryIconURL)
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 4)
    }
}

//#Preview {
//    PlaceRow()
//}
