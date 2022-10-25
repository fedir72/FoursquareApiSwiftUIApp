//
//  FoursquareProvider.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import Foundation
import Moya

let gpapikey = "fsq32dzAV8r/OXuMCplCeaU12WsxRFAuKZeXRlByPc0PfS0="
let somekey = "fsq3Tl7FUUXvL0+OQj4iQLnCepvCUOjR6Vzxhp3QZjknmj8="

//https://api.foursquare.com/v3/places/search?query=mobile
//https://api.foursquare.com/v3/places/56ebc76138fa609a6ee2e560/photos
//https://api.foursquare.com/v3/places/nearby?query=mobile
//https://api.foursquare.com/v3/places/541327ea498ee067d851a158
//https://api.foursquare.com/v3/places/nearby?query=coffee&ll=28.07,-16.43&radius=1000&limit=50
//https://api.foursquare.com/v3/places/541327ea498ee067d851a158/tips

enum FoursquareService {
    case getPlaces(term: String,category: String,lat: Double,long: Double, radius: Int, limit: Int)
    case getNearbyPlaces(term: String,lat: Double,long: Double, radius: Int, limit: Int)
    case placeIDetails(id: String)
    case placePhotos(id: String)
    case placeTips(id: String)
}


extension FoursquareService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.foursquare.com/v3/places/" )!
    }
    
    var path: String {
        switch self {
            
        case .getPlaces(_,_,_,_,_,_):
            return "search"
        case .getNearbyPlaces(_,_,_,_,_):
            return "nearby"
        case .placeIDetails(let id):
            return "\(id)"
        case .placePhotos(let id):
            return "\(id)/photos"
        case .placeTips(let id):
            return "\(id)/tips"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getPlaces(let term, let category ,let lat, let long, let radius, let limit):
            return .requestParameters(parameters: [
                "query": term,
                "categories": category,
                "ll": "\(lat),\(long)",
                "radius": radius,
                "limit":limit], encoding: URLEncoding.default)
        case .getNearbyPlaces(let term, let lat, let long, let radius, let limit):
            return .requestParameters(parameters: [
                "query": term,
                "ll": "\(lat),\(long)",
                "radius": radius,
                "limit": limit], encoding: URLEncoding.default)
        case .placeIDetails(_):
            return .requestPlain
        case .placeTips(_),.placePhotos(_):
            return .requestParameters(parameters: [
                "limit":"50",
                "sort":"newest"
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json",
                "Accept-Language": "en",
                "Authorization": gpapikey,
                "User-agent": "ReadMe-API-Explorer"]
    }
    
    
}
