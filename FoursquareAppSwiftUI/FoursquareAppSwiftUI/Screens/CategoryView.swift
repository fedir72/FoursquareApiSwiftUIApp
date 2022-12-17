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
                      Text("Categories")
                          .foregroundColor(.white)
                          .font(.title2.bold())
                          .padding(.leading, 14)
                      Spacer()
                  }
                  .padding(.bottom, 10)

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
                .scrollDisabled(true)
                .listStyle(.plain)
            
            }
            .background(Color.gray)
        }
    
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(searchCategoryIndex: .constant(15000),
                     showCategoryView: .constant(false))
    }
}
