//
//  TestView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 23.08.25.
//

import SwiftUI

struct TestView: View {
  var body: some View {
    GeometryReader { geo in
      ZStack(alignment: .center){
        Image(systemName: "umbrella.fill") // фон для демонстрации
          .resizable()
          .tint(.brown)
        Text("Привет, мир!")
          .font(.largeTitle)
          .padding()
          .background(.ultraThinMaterial) // полупрозрачный размытой фон
          .cornerRadius(15)
        
        
      }
    }.padding(40)
  }
}

#Preview {
    TestView()
}
