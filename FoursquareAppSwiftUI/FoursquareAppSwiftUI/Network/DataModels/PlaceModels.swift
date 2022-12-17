

import Foundation

struct Place: Decodable {
    let fsq_id: String
    let categories: [Category]
    let geocodes: Main
    let link: String
    let location: Location
    let name: String
    let timezone: String?
    }

struct Location: Decodable {
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
 
    func iconURl(resolution: IconResolution) -> URL? {
        let str = self.prefix + resolution.rawValue + self.suffix
        //print(str)
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
    
    

