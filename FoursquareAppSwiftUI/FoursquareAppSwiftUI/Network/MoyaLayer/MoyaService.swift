//
//  MoyaService.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import UIKit
import Moya
//import Combine

class Foursquare {
    
    //@Published var places = [Place]()
    let moya = MoyaProvider<FoursquareService>()
    
    static let shared = Foursquare()
    private init() { }
    
   func decodejson<T:Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print("data has been not decoded : \(error.localizedDescription)")
            return nil
        }
    }
    
    func getNearestPlaces(term: String?,
                          category index: String?,
                          lat: Double,long: Double , completion: @escaping (Result<Places,Error>) -> ()) {
        self.moya.request(
            .getPlaces(
                term: term ?? "",
                category: index ?? "" ,
                lat: lat,
                long: long,
                radius: 1000,
                limit: 50)) { result in
                    switch result {
                        case .success(let responce):
                        guard let value =
                        self.decodejson(type: Places.self, from: responce.data)
                        else { return }
                        completion(.success(value))
                        case .failure(let error):
                        completion(.failure(error))
                           }
                       }
                   }
  
}
