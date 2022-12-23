//
//  LocationManager.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 23.12.2022.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static var shares = LocationManager()
    
    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = 1000
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("debug not")
        case .restricted:
            print("debug  restict")
        case .denied:
            print("debug denied ")
        case .authorizedAlways:
            print("debug always")
        case .authorizedWhenInUse:
            print("debug when in use")
           // manager.requestWhenInUseAuthorization()
        case .authorized:
            print("debug ")
            
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        print("location is")
        manager.stopUpdatingLocation()
    }

}
