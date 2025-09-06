//
//  PlacesDataSource.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 17.08.25.
//

import SwiftUI

final class PlacesDataSource: ObservableObject {
    
    // MARK: - Наблюдаемые свойства
    @Published var nearbyPlaces: [Place] = []        // getPlacesNearbyMe / getPlacesBy
    @Published var selectedPlace: Place? = nil      // getPlaceDetails
    @Published var placePhotos: [PhotoItem] = []    // getPlacePhotos
    @Published var placeTips: [Tip] = []           // getPlaceTips
    @Published var cities: [OpenMapCity] = []
  
    @Published var lastLoadedCity: String? = nil
  
    private let networkProvider: NetworkProvider
  
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    // MARK: - Методы загрузки данных
  // Получение мест через поиск (getPlaces)
  func getPlaces(term: String?, category: String?, lat: Double, long: Double) {
      networkProvider.getPlacesBy(term: term,
                                  category: category,
                                  lat: lat, lon: long) { [weak self] result in
          DispatchQueue.main.async {
              switch result {
              case .success(let places):
                  self?.nearbyPlaces = places   // одно и то же свойство
              case .failure(let error):
                  print("Failed to fetch places: \(error)")
                  self?.nearbyPlaces = []
              }
          }
      }
  }
  
//    func loadNearbyPlaces(lat: Double, long: Double) {
//        networkProvider.getPlacesNearbyMe(lat: lat,
//                                          long: long) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let places):
//                    self?.nearbyPlaces = places
//                case .failure(let error):
//                    print("Ошибка загрузки nearbyPlaces: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
  
  func loadNearbyPlaces(for cityName: String, lat: Double, long: Double) {
      // проверяем, не загружали ли мы уже этот город
      if lastLoadedCity == cityName {
          print("Места уже загружены для города: \(cityName), пропускаем")
          return
      }
      
      lastLoadedCity = cityName //! обновляем флаг
      
      networkProvider.getPlacesNearbyMe(lat: lat,
                                        long: long) { [weak self] result in
          DispatchQueue.main.async {
              switch result {
              case .success(let places):
                  self?.nearbyPlaces = places
              case .failure(let error):
                  print("Ошибка загрузки nearbyPlaces: \(error.localizedDescription)")
              }
          }
      }
  }
  
  
    
    func loadPlaceDetails(id: String) {
        networkProvider.getPlaceDetails(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let place):
                    self?.selectedPlace = place
                case .failure(let error):
                    print("Ошибка загрузки selectedPlace: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func loadPlacePhotos(id: String) {
        networkProvider.getPlacePhotos(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self?.placePhotos = photos
                case .failure(let error):
                    print("Ошибка загрузки placePhotos: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func loadPlaceTips(id: String) {
        networkProvider.getPlaceTips(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tips):
                    self?.placeTips = tips
                case .failure(let error):
                    print("Ошибка загрузки placeTips: \(error.localizedDescription)")
                }
            }
        }
    }
  
  
  func loadCities(by term: String, limit: Int) {
    networkProvider.getCities(term: term, limit: limit) {[weak self] result in
      switch result {
        
      case .success(let cityes):
        self?.cities = cityes
      case .failure(let error):
        print("Ошибка загрузки Cityes: \(error.localizedDescription)")
      }
    }
  }
}
