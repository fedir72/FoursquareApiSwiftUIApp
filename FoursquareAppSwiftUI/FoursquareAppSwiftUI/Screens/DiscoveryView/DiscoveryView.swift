//
//  MainView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 17.12.2022.
//

import SwiftUI


struct DiscoveryView: View {
  
  @State var searchCategoryIndex: Int = 19000
  @State var showCategoryView: Bool = false
  
  let realmCity: RealmCity
  let isUserPosition: Bool
  
  var body: some View {
    
    ZStack {
      CategoryView(searchCategoryIndex: $searchCategoryIndex,
                   showCategoryView: $showCategoryView)
      GeoPositionView(showCategories: $showCategoryView,
                      searchCategoryIndex: $searchCategoryIndex,
                      realmCity: realmCity, isUserPosition: isUserPosition)
      .offset(x: self.showCategoryView ? 250 : 0, y: 0)
      .animation(.default,value: self.showCategoryView)
    }
  }
}

//#Preview {
//  DiscoveryView()
//}
