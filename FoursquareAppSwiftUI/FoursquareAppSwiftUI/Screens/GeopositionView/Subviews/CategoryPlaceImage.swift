//
//  CategoryPlaceImage.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 15.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI


struct CategoryPlaceImage: View {
      let url: URL?
      var body: some View {
          VStack{
              if let url = url {
                  WebImage(url: url)
                      .resizable()
                      .frame(width: 50, height: 50)
              } else {
                  Image(systemName: "mappin")
                      .resizedToFill(width: 50, height: 50)
              }
          }
          .background(Color("SearchCellBackground"))
          .aspectRatio(contentMode: .fit)
          .cornerRadius(10)
          .font(.title)
          .foregroundColor(.white)
         
      }
}


//struct CategoryPlaceImage_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack(spacing: 20) {
//            CategoryPlaceImage(url: URL(string: "https://ss3.4sqi.net/img/categories_v2/food/tapas_64.png"))
//            CategoryPlaceImage(url: nil) // mock example
//        }
//        .previewLayout(.sizeThatFits)
//    }
//}
