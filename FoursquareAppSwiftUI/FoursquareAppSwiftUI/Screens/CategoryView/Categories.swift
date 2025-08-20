//
//  Categories.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 15.12.2022.
//

import Foundation

enum Categories: String, CaseIterable {
    
    case artsAndEntertainment
    case businessAndProfessionalServices
    case communityAndGovernment
    case diningAndDrinking
    case event
    case healthAndMedicine
    case landmarksAndOutdoors
    case retail
    case sportsAndRecreation
    case travelAndTransportation
    
    var imageName: String {
        switch self {
        case .artsAndEntertainment: return "theatermasks"
        case .businessAndProfessionalServices: return "dollarsign.square"
        case .communityAndGovernment: return "building.columns.fill"
        case .diningAndDrinking: return "cup.and.saucer.fill"
        case .event: return "person.3"
        case .healthAndMedicine: return "heart.circle.fill"
        case .landmarksAndOutdoors: return "globe.europe.africa"
        case .retail: return "cart.fill"
        case .sportsAndRecreation: return "sportscourt.fill"
        case .travelAndTransportation: return "airplane.circle"
            
        }
    }
    
    var searchIndex: Int {
        switch self {
        case .artsAndEntertainment: return 10000
        case .businessAndProfessionalServices: return 11000
        case .communityAndGovernment: return  12000
        case .diningAndDrinking: return 13000
        case .event: return 14000
        case .healthAndMedicine: return 15000
        case .landmarksAndOutdoors: return 16000
        case .retail: return 17000
        case .sportsAndRecreation: return 18000
        case .travelAndTransportation: return 19000
            
        }
    }
    
    var titleText: String {
        switch self {
            
        case .artsAndEntertainment: return " Arts and entertainment"
        case .businessAndProfessionalServices: return "Businnes and services"
        case .communityAndGovernment: return "Community and goverment"
        case .diningAndDrinking: return "Dining and drinking"
        case .event: return "Events"
        case .healthAndMedicine: return "Health end medicine"
        case .landmarksAndOutdoors: return "Landmarks and Outdoors"
        case .retail: return "Retail"
        case .sportsAndRecreation: return "Sport and recreation"
        case .travelAndTransportation: return "Travel and transportation"
        }
    }
    
}
