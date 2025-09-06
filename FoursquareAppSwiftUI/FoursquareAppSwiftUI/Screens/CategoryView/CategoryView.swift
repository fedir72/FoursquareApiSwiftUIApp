//
//  CategoryView.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 15.12.2022.
//

import SwiftUI

struct CategoryView: View {
  
  @Binding var searchCategoryIndex: Int
  @Binding var showCategoryView: Bool
  
  var body: some View {
    
    VStack {
      HStack {
        Button {
          showCategoryView.toggle()
        } label: {
          Image(systemName: "xmark.square")
            .foregroundColor(.blue)
            .font(.largeTitle)
            .padding(6)
        }
        Text("categories")
          .font(.title2.bold())
          .foregroundColor(.white)
        Spacer()
      }
      .padding(5)
      .background(Color.gray)
      
      
      List {
        ForEach(Categories.allCases, id:  \.imageName) { category in
          HStack {
            Image(systemName: category.imageName)
              .resizedToFill(width: 30, height: 30)
            Text(category.titleText)
              .font(.system(size: 17))
            Spacer()
          }
          .onTapGesture {
            print(category.searchIndex)
            showCategoryView.toggle()
            searchCategoryIndex = category.searchIndex
            
          }
        }
      }
      .listStyle(.plain)
    }
  }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(searchCategoryIndex: .constant(15000),
                     showCategoryView: .constant(false))
    }
}
