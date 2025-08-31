//
//  NetworkProvider.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 17.08.25.
//

import UIKit
import Moya


class NetworkProvider {
  
  init() {}

  let foursquare = MoyaProvider<FoursquareService>()
  let openweather = MoyaProvider<OpenWeatherMapService>()

  // MARK: - Generic JSON Decoder
  private func decodeJSON<T: Decodable>(type: T.Type,
                                        from data: Data?) -> Result<T, Error> {
    guard let data = data else {
      return .failure(NSError(domain: "NetworkProvider",
                              code: -1,
                              userInfo: [NSLocalizedDescriptionKey: "No data"]))
    }
    let decoder = JSONDecoder()
    do {
      let object = try decoder.decode(type, from: data)
      return .success(object)
    } catch {
      print("[Decode Error] \(T.self): \(error.localizedDescription)")
      return .failure(error)
    }
  }

  // MARK: - Universal Request Method
  private func request<T: Decodable>(
    _ target: FoursquareService,
    responseType: T.Type,
    completion: @escaping (Result<T, Error>) -> Void
  ) {
    foursquare.request(target) { result in
      switch result {
      case .success(let response):
        let decodedResult = self.decodeJSON(type: responseType, from: response.data)
        completion(decodedResult)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  // MARK: - Public API

  func getPlacesNearbyMe(
    lat: Double,
    long: Double,
    completion: @escaping (Result<[Place], Error>) -> Void
  ) {
    request(.getNearbyPlaces(term: "", lat: lat, long: long,
                             radius: 1000, limit: 50),
                             responseType: PlacesNearbe.self) { result in
      switch result {
      case .success(let data):
        completion(.success(data.results))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func getPlacesBy(
    term: String?,
    category index: String?,
    lat: Double,
    lon: Double,
    completion: @escaping (Result<[Place], Error>) -> Void
    ) {
    request(.getPlaces(term: term ?? "", category: index ?? "19000",
                       lat: lat, long: lon, radius: 1000, limit: 50),
                       responseType: Places.self) { result in
      switch result {
      case .success(let data):
        completion(.success(data.results))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func getPlaceDetails(
    id: String,
    completion: @escaping (Result<Place, Error>) -> Void
  ) {
    request(.placeIDetails(id: id),
            responseType: Place.self,
            completion: completion)
  }

  func getPlacePhotos(
    id: String,
    completion: @escaping (Result<[PhotoItem], Error>) -> Void
  ) {
    request(.placePhotos(id: id),
            responseType: [PhotoItem].self,
            completion: completion)
  }

  func getPlaceTips(
    id: String,
    completion: @escaping (Result<[Tip], Error>) -> Void
  ) {
    request(.placeTips(id: id),
            responseType: [Tip].self,
            completion: completion)
  }
  
  
  // MARK: - OpenWeatherMap Methods
  func getCities(
      term: String,
      limit: Int = 10,
      completion: @escaping (Result<[OpenMapCity], Error>) -> Void
  ) {
      openweather.request(.getCities(term: term, limit: limit)) { result in
          switch result {
          case .success(let response):
              let decodedResult = self.decodeJSON(type: [OpenMapCity].self, from: response.data)
              completion(decodedResult)
          case .failure(let error):
              completion(.failure(error))
          }
      }
  }
  
  
}
