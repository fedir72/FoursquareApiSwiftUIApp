//
//  LoadinfView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 21.08.25.
//

import SwiftUI

struct LoadingView: View {
  var body: some View {
    VStack(alignment: .center, spacing: 16) {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
        .scaleEffect(2)
      
      Text("Loading...")
        .foregroundColor(Color(.label))
        .font(.headline)
    }
    .padding(24)
    .background(Color(.secondarySystemBackground))
    .cornerRadius(12)
    .shadow(radius: 10)
  }
}

//#Preview {
//  LoadingView()
//}
