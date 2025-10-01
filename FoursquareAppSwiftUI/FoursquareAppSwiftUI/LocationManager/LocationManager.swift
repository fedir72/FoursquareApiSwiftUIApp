//
//  LocationManager.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 23.12.2022.
//

//import CoreLocation
import MapKit
import Foundation
import RealmSwift

enum MapDetails {
    static let startLocation = CLLocationCoordinate2D(latitude: 35.658581,
                                                      longitude: 139.745438)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.013,
                                               longitudeDelta: 0.013)
}


class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocation? {
        didSet {
            if let loc = userLocation {
                print("loc", loc.coordinate.latitude, loc.coordinate.longitude)
            }
        }
    }
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startLocation,
                                               span: MapDetails.defaultSpan)
    @Published var centerAddress: String = "somewhere"
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermissionAndStart() {
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
    
    func updateAddress(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                var address = ""
                if let name = placemark.name { address += name }
                if let locality = placemark.locality { address += ", \(locality)" }
                if let country = placemark.country { address += ", \(country)" }
                
                DispatchQueue.main.async {
                    self.centerAddress = address
                }
            } else if let error = error {
                print("geocoding error: \(error.localizedDescription)")
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // запускаем обновление,
        // если юзер уже дал доступ
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location
            self.region = MKCoordinateRegion(center: location.coordinate,
                                             span: MapDetails.defaultSpan)
        }
        manager.stopUpdatingLocation()
    }
  
  //MARK: - getting the current city by geolocation ( RealmCity )
  func getCurrentCity(completion: @escaping (RealmCity?) -> Void) {
      guard let location = userLocation else {
          completion(nil)
          return
      }
    
    let geocoder = CLGeocoder()
    //MARK: - names of cities in English
    let locale = Locale(identifier: "en_US")
    geocoder.reverseGeocodeLocation(location,
                                     preferredLocale: locale)  { placemarks, error in
      guard error == nil,
            let placemark = placemarks?.first,
            let cityName = placemark.locality,
            let country = placemark.country else {
        completion(nil)
        return
      }
      
      let city = RealmCity()
      city._id = UUID().uuidString
      city.name = cityName
      city.lat = location.coordinate.latitude
      city.lon = location.coordinate.longitude
      city.country = country
      city.state = placemark.administrativeArea
      DispatchQueue.main.async {
        completion(city)
      }
    }
  }
    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get user location: \(error.localizedDescription)")
//    }
  
  //MARK: - Search for a city close to your current location in Realm
  func findExistingCity(in realm: Realm, toleranceMeters: Double = 1000) -> RealmCity? {
      guard let userLocation = userLocation else { return nil }

      let allCities = realm.objects(RealmCity.self)
      
      return allCities.first { city in
          let cityLocation = CLLocation(latitude: city.lat, longitude: city.lon)
          let distance = cityLocation.distance(from: userLocation)
          return distance <= toleranceMeters
      }
  }
  
  //MARK: - comparison of coordinates with the specified tolerance
  func isSamePlace(_ coord1: CLLocationCoordinate2D,
                   _ coord2: CLLocationCoordinate2D,
                   toleranceMeters: Double = 100) -> Bool {
      let loc1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
      let loc2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
      return loc1.distance(from: loc2) <= toleranceMeters
  }
  
}
