//
//  CategoryPlaceImage.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 15.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryPlaceMarker: View {
    let url: URL?
    var body: some View {
        VStack{
            if let url = url {
                AnimatedImage(url: url)
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

struct CategoryPlaceImage_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPlaceMarker(url:
                            URL(string: "https://ss3.4sqi.net/img/categories_v2/food/tapas_"))
    }
}
