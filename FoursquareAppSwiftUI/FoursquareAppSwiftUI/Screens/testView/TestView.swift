//
//  TestView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 23.08.25.
//

import SwiftUI

struct TestView: View {
  
  var body: some View {
      apologizeView()
  }
  
  //MARK: - apologizeView
   private func apologizeView() -> some View {
       VStack(spacing: 0) {
           Image(systemName: "wrongwaysign")
              .font(.largeTitle).bold()
           Text("\nUnfortunately\nthis photo cannot be downloaded\nin full resolution")
              .multilineTextAlignment(.center)
              .font(.title2)
       }
     .foregroundStyle(.red)
   }
  
}

#Preview {
    TestView()
}
