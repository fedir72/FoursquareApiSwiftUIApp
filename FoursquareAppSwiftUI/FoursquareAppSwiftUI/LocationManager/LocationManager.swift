//
//  LocationManager.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 23.12.2022.
//

//import CoreLocation
import MapKit

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
