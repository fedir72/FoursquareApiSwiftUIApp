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
    
    // Для сборки URL категории, как в Place.Icon
    @Persisted var categoryIconPrefix: String? = nil
    @Persisted var categoryIconSuffix: String? = nil
    
    @Persisted var lat: Double = 0
    @Persisted var lon: Double = 0
    @Persisted var formattedAddress: String? = nil
    @Persisted var country: String? = nil
    @Persisted var timezone: String? = nil
    @Persisted var link: String? = nil
    
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
        
        if let category = apiPlace.categories.first {
            self.categoryName = category.name
            self.categoryIconPrefix = category.icon.prefix
            self.categoryIconSuffix = category.icon.suffix
        }
    }
    
    // MARK: - Icon URL builder
    enum IconResolution: String {
        case micro = "32"
        case small = "44"
        case medium = "64"
        case big = "88"
        case large = "120"
    }
    
    /// Returns URL for category icon with given resolution
    func iconURL(resolution: IconResolution = .medium) -> URL? {
        guard let prefix = categoryIconPrefix, let suffix = categoryIconSuffix else { return nil }
        return URL(string: prefix + resolution.rawValue + suffix)
    }
}


