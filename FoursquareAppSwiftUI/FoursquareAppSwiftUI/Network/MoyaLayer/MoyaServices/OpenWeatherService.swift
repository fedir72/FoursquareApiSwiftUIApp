//
//  OpenWeatherService.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 28.08.25.
//

import Foundation
import Moya

struct ApisOpenweather {
    static  let mainUrlGeo: String = "https://api.openweathermap.org/"
    static  let mainUrl: String = "https://api.openweathermap.org/data/"
    static  let id: String = "b66e60708f68ae585271c30665c1382c"
    static  let id2: String = "b66e60708f68ae585271c30665c1382c"
}
//MARK: - urlStr example
//https://api.openweathermap.org/geo/1.0/direct?q=Red&limit=10&appid=b66e60708f68ae585271c30665c1382c

enum OpenWeatherMapService {
    case getCities(term: String, limit: Int)
}

extension OpenWeatherMapService: TargetType {
    var baseURL: URL {
        return URL(string: ApisOpenweather.mainUrlGeo )!
    }
    
    var path: String {
        switch self {
        case .getCities(_,_):
        return  "geo/1.0/direct"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCities(_,_):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCities(let term, limit: let limit ):
            return .requestParameters(parameters: [
                "q":"\(term)",
                "limit":"\(limit)",
                "appid":"\(ApisOpenweather.id)",],
                encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCities(_,_):
            return nil
        }
    }
    
    
}
