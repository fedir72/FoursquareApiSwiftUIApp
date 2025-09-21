//
//  RealmPlace.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 13.09.25.
//

import Foundation
import RealmSwift

class RealmPlace: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: String   // fsq_id из API
    @Persisted var name: String = ""
    @Persisted var categoryName: String? = nil
    @Persisted var lat: Double = 0
    @Persisted var lon: Double = 0
    @Persisted var formattedAddress: String? = nil
    @Persisted var country: String? = nil
    @Persisted var timezone: String? = nil
    @Persisted var link: String? = nil
    @Persisted var categoryImageUrlStr: String?
    
    // MARK: - Init from API Place
    convenience init(from apiPlace: Place) {
        self.init()
        self._id = apiPlace.id
        self.name = apiPlace.name
        self.lat = apiPlace.geocodes.main?.latitude ?? 0
        self.lon = apiPlace.geocodes.main?.longitude ?? 0
        self.formattedAddress = apiPlace.location.formatted_address
        self.country = apiPlace.location.country
        self.timezone = apiPlace.timezone
        self.link = apiPlace.link
        self.categoryImageUrlStr = apiPlace.categories.first?.icon.iconUrlStr()
        if let category = apiPlace.categories.first {
            self.categoryName = category.name
        }
    }
    
    
    /// Returns URL for category icon with given resolution
    func iconURL() -> URL? {
      guard let urlStr = self.categoryImageUrlStr else { return nil }
      return URL(string: urlStr)
    }
}


