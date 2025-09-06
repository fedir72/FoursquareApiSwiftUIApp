//
//  CarouselView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 25.08.25.

import SwiftUI

struct FullScreenPhotoCarouselView: View {
    
  //MARK: - propertys
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataSource: PlacesDataSource
  
    @Binding var selectedIndex: Int
    @State private var dragOffset: CGFloat = 0
    
    //MARK: - body
    var body: some View {
        ZStack {
          Color.black
          .background(.clear)
          .ignoresSafeArea()
          
            if dataSource.placePhotos.isEmpty {
                // MARK: - Заглушка
                Text("Нет доступных фото")
                    .foregroundColor(.white)
                    .font(.headline)
            } else {
                GeometryReader { geo in
                    HStack(spacing: 0) {
                        ForEach(dataSource.placePhotos.indices, id: \.self) { index in
                            ZoomPhotoView(photoItem: dataSource.placePhotos[index])
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipped()
                        }
                    }
                    // Смещаем все фото так, чтобы на экране был selectedIndex
                    .offset(x: -CGFloat(selectedIndex) * geo.size.width)
                    .offset(x: dragOffset) // во время свайпа
                    .animation(.easeInOut, value: selectedIndex)
                }
                .ignoresSafeArea()
                
                // Индикатор
                VStack {
                    Spacer()
                    Text("\(selectedIndex + 1) / \(dataSource.placePhotos.count)")
                    .font(.headline)
                      .foregroundColor(.white)
                      .padding(.horizontal, 12)
                      .padding(.vertical, 6)
                      .background(Color.black.opacity(0.4))
                      .clipShape(Capsule())
                      .shadow(color: .black.opacity(0.7), radius: 4)
                }
          
                VStack {
                    Spacer()
                   //MARK: - navigation buttons
                    HStack(spacing: 15) {
                        Button {
                            if selectedIndex > 0 {
                                withAnimation {
                                    selectedIndex -= 1
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.left.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(selectedIndex > 0 ? .white : .gray)
                            .shadow(color: .black.opacity(0.6), radius: 4)
                        }
                        .disabled(selectedIndex == 0)
                       
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.red)
                        }
                       
                        Button {
                            if selectedIndex < dataSource.placePhotos.count - 1 {
                                withAnimation {
                                    selectedIndex += 1
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(selectedIndex < dataSource.placePhotos.count - 1 ? .white : .gray)
                                .shadow(color: .black.opacity(0.6), radius: 4)
                         }
                        .disabled(selectedIndex == dataSource.placePhotos.count - 1)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}








