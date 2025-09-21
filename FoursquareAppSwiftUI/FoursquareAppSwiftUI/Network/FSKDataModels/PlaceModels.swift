

import Foundation
import MapKit

struct Place: Decodable,
              Identifiable {
  
  
  let id: String
  let categories: [Category]
  let geocodes: Main
  let link: String
  let location: MapAdress
  let name: String
  let timezone: String?
  
  func location2D() -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: geocodes.main?.latitude ?? MapDetails.startLocation.latitude,
      longitude: geocodes.main?.longitude ?? MapDetails.startLocation.longitude)
  }
  
}

extension Place {
  
  enum CodingKeys: String, CodingKey {
    case id = "fsq_id"
    case categories,geocodes,link,location,name,timezone
  }
  
  
}

struct MapAdress: Decodable {
  let country: String
  let cross_street: String?
  let formatted_address: String?
}

struct Category: Decodable {
  let  id: Int
  let  name: String
  let  icon:  Icon
}

struct Icon: Decodable {
  let   prefix: String
  let   suffix: String
  
  //32, 44, 64, 88, or 120
  enum IconResolution: String {
    case micro = "32"
    case small = "44"
    case medium = "64"
    case big = "88"
    case large = "120"
  }
  
  func iconUrlStr() -> String? {
    return self.prefix + String(44) + self.suffix
  }
  
  func iconURl(resolution: IconResolution) -> URL? {
    let str = self.prefix + resolution.rawValue + self.suffix
    return URL(string: str)
  }
}

struct Main: Decodable {
  let main: GeoPoint?
}

struct GeoPoint: Decodable {
  let latitude: Double?
  let longitude: Double?
}

    

