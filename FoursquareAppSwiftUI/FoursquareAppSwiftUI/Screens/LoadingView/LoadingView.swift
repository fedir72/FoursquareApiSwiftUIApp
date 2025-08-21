//
//  LoadinfView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 21.08.25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            // Белый фон
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(
                     // LinearProgressViewStyle()
                      CircularProgressViewStyle(tint: .blue)
                    )
                    .scaleEffect(2)
                
                Text("Загрузка...")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
        }
    }
}
#Preview {
  LoadingView()
}
