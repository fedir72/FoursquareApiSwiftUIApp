//
//  DetailGridCell.swift
//  FoursquareAppSwiftUI
//
//  Created by Fedii Ihor on 21.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailGridCell: View {
    
    let photoItem: PhotoItem
    
    var body: some View {
        ZStack {
            AnimatedImage(url: photoItem.photoUrlStr(w: 200, h: 200))
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack {
                HStack {
                    Spacer()
                    Text(photoItem.dateStr())
                        .padding(.top, 5)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                }
                .padding(.trailing, 5)
                Spacer()
                
            }
        }
        .cornerRadius(10)
    }
    
}

struct DetailGridCell_Previews: PreviewProvider {
    static var previews: some View {
        DetailGridCell(photoItem:PhotoItem(id: Optional("5b2f6b4cb9ac38002c85ec5f"), created_at: Optional("2018-06-24T09:58:36.000Z"), prefix: Optional("https://fastly.4sqi.net/img/general/"), suffix: Optional("/1609346_fmd3jxZoWs7FAM6jfnyHM8mTn9JGIyhn1q0SECmOA14.jpg"), width: Optional(1920), height: Optional(1440)))
            .frame(width: 150, height: 150)
    }
}
