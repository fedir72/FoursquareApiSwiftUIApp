//
//  MoyaService.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 25.10.2022.
//

import UIKit
import Moya
//import Combine

//class DataFetcher {
//
//    private let moya = MoyaProvider<FoursquareService>()
//    static let shared = DataFetcher()
//    private init() { }
//    
//  private func decodejson<T:Decodable>(type: T.Type, from: Data?) -> T? {
//        let decoder = JSONDecoder()
//        guard let data = from else { return nil }
//        
//        do {
//            let objects = try decoder.decode(type.self, from: data)
//            return objects
//        } catch let error {
//            print("data has been not decoded : \(error.localizedDescription)")
//            return nil
//        }
//    }
//    
//    //MARK: - public func
//    func getNearestPlaces(term: String?,
//                          category index: String?,
//                          lat: Double,long: Double ,
//                          completion: @escaping (Result<Places,Error>) -> Void) {
//        self.moya.request(
//            .getPlaces(
//                term: term ?? "",
//                category: index ?? "" ,
//                lat: lat,
//                long: long,
//                radius: 1000,
//                limit: 50)) { result in
//                    switch result {
//                        case .success(let responce):
//                        guard let value =
//                        self.decodejson(type: Places.self, from: responce.data)
//                        else { return }
//                        completion(.success(value))
//                        case .failure(let error):
//                        completion(.failure(error))
//                           }
//                       }
//                   }
//    
//    func searchPlacePhotos(by id: String,
//                           completion: @escaping(Result<Photos,Error>) -> Void) {
//        self.moya.request(.placePhotos(id: id)) { result in
//            switch result {
//            case .success(let responce):
//                // print("Data", String(data: responce.data, encoding: .utf8))
//                let items = self.decodejson(type: Photos.self, from: responce.data)
//                completion(.success(items ?? []))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getTips(by placeId: String,
//                 completion: @escaping (Result<Tips,Error>) -> Void) {
//        moya.request(.placeTips(id: placeId)) { result in
//            switch result {
//            case .success(let responce):
//                guard let newSource = self.decodejson(type: Tips.self, from: responce.data)
//                else { completion(.success([])) ; return }
//                completion(.success(newSource))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//  
//}
