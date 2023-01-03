//
//  LocationManager.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 23.12.2022.
//

//import CoreLocation
import MapKit

enum MapDetails {
    static let startLocation = CLLocationCoordinate2D(latitude: 36.02417,
                                                      longitude: 49.89333)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.013,
                                               longitudeDelta: 0.013)
}

class LocationManager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var region = MKCoordinateRegion(center: MapDetails.startLocation,
                                               span: MapDetails.defaultSpan)
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
        case .authorizedWhenInUse, .authorizedAlways:
            print("debug ")
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
        region = MKCoordinateRegion(center: userLocation?.coordinate ?? MapDetails.startLocation,
                                    span: MapDetails.defaultSpan)
        print("location is")
        manager.stopUpdatingLocation()
    }

}
