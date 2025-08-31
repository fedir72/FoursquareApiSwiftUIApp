//
//  LocationManager.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 23.12.2022.
//

//import CoreLocation
import MapKit
import Foundation

enum MapDetails {
    static let startLocation = CLLocationCoordinate2D(latitude: 35.658581,
                                                      longitude: 139.745438)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.013,
                                               longitudeDelta: 0.013)
}



import SwiftUI
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
  @Published var userLocation: CLLocation?  {
    didSet {
      print("loc",
            userLocation!.coordinate.latitude,
            userLocation!.coordinate.longitude)
    }
  }
    @Published var region = MKCoordinateRegion(center: MapDetails.startLocation,
                                               span: MapDetails.defaultSpan)
    
   override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorization()
    }
    
  func checkAuthorization() {
      switch manager.authorizationStatus {
      case .authorizedWhenInUse, .authorizedAlways:
          manager.startUpdatingLocation()
      case .notDetermined:
          manager.requestWhenInUseAuthorization()
      case .restricted, .denied:
          print("Доступ к локации запрещен")
      @unknown default:
          break
      }
  }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location
            self.region = MKCoordinateRegion(center: location.coordinate,
                                             span: MapDetails.defaultSpan)
        }
        manager.stopUpdatingLocation() // если нужен один апдейт
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}

//extension LocationManager {
//    func searchCities(query: String, completion: @escaping ([City]) -> Void) {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = query
//        request.resultTypes = .address  // ищем именно адреса/города
//
//        let search = MKLocalSearch(request: request)
//        search.start { response, error in
//            if let error = error {
//                print("Ошибка поиска: \(error.localizedDescription)")
//                completion([])
//                return
//            }
//            
//            guard let response = response else {
//                completion([])
//                return
//            }
//            
//            let cities: [City] = response.mapItems.compactMap { item in
//                guard let name = item.name else { return nil }
//                let country = item.placemark.country
//                let coordinate = item.placemark.coordinate
//                let timeZone = item.timeZone
//                
//                return City(name: name,
//                            country: country,
//                            coordinate: coordinate,
//                            timeZone: timeZone)
//            }
//            
//            completion(cities)
//        }
//    }
//}

//locationManager.searchCities(query: "Tokyo") { results in
//    for city in results {
//        print(city.name ?? "Без названия",
//              city.placemark.coordinate.latitude,
//              city.placemark.coordinate.longitude)
//    }
//}
