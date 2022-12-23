//
//  MainView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 17.12.2022.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var locationManager = LocationManager.shares
    @State var searchCategoryIndex: Int = 0
    @State var showCategoryView: Bool = false
    
    var body: some View {
        if locationManager.userLocation == nil {
            LocationRequestView()
        } else {
            ZStack {
                CategoryView(searchCategoryIndex: $searchCategoryIndex,
                             showCategoryView: $showCategoryView)
                GeopointView(showCategories: $showCategoryView,
                             searchCategoryIndex: $searchCategoryIndex)
                .offset(x: self.showCategoryView ? 250 : 0, y: 0)
                .animation(.easeIn,value: self.showCategoryView)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
