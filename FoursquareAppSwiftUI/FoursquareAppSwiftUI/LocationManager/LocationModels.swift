//
//  File.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 28.08.25.
//

import Foundation
import MapKit

/// Модель города
struct City {
  let name: String              // Название города
  let country: String?          // Страна
  let coordinate: CLLocationCoordinate2D  // Координаты
  let timeZone: TimeZone?       // Часовой пояс
  let address: String?                 // Полный адрес как текст
}




//class MKMapItem : NSObject {
//    var name: String?                  // Название (например "Москва")
//    var placemark: MKPlacemark         // Адрес и координаты
//    var phoneNumber: String?           // Телефон (если это POI)
//    var url: URL?                      // Сайт (если есть)
//    var timeZone: TimeZone?            // Часовой пояс
//    var isCurrentLocation: Bool        // Текущая локация?
//}

//class MKPlacemark : CLPlacemark {
//    var coordinate: CLLocationCoordinate2D   // координаты
//    var country: String?                     // страна ("Россия")
//    var administrativeArea: String?          // область / регион ("Москва")
//    var locality: String?                    // город ("Москва")
//    var subLocality: String?                 // район
//    var thoroughfare: String?                // улица
//    var subThoroughfare: String?             // номер дома
//}

//public struct CLLocationCoordinate2D {
//    var latitude: CLLocationDegrees   // Double
//    var longitude: CLLocationDegrees  // Double
//}
