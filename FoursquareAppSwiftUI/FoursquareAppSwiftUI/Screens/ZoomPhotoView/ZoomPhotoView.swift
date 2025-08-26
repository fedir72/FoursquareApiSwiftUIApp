//
//  ZoomPhotoView.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 23.08.25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ZoomPhotoView: View {
  
  //MARK: - properties
    let photoItem: PhotoItem
    @Environment(\.dismiss) var dismiss

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @State private var imageFrame: CGSize = .zero // реальный размер картинки
    
    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 4.0
    
  //MARK: - body
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                
                VStack {
                   // infoHeaderView(photoItem.dateStr())
                   //   .padding(20)
                    if let w = photoItem.width,
                       let h = photoItem.height,
                       let url = photoItem.photoUrlStr(w: w, h: h) {
                           photoView(with: url, containerSize: geo.size)
                            .frame(width: geo.size.width, height: geo.size.height)
                    } else {
                        apologizeView()
                    }
                }
            }
        }
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
  
  //MARK: - infoHeaderView
  private func infoHeaderView(_ dateText: String) -> some View {
        HStack {
            Text("Added: \(dateText)")
                .font(.headline)
                .tint(.white)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.largeTitle)
            }
        }
    }
  
    //MARK: - photoView
    private func photoView(with url: URL, containerSize: CGSize) -> some View {
        WebImage(url: url)
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .offset(offset)
            .background(
                GeometryReader { imgGeo in
                    Color.clear
                        .onAppear {
                            imageFrame = imgGeo.size
                        }
                        .onChange(of: scale) { _ in
                            offset = clampedOffset(containerSize: containerSize,
                                                   imageSize: imageFrame,
                                                   proposedOffset: offset)
                        }
                }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let newScale = lastScale * value
                        scale = min(max(newScale, minScale), maxScale)
                        offset = clampedOffset(containerSize: containerSize,
                                               imageSize: imageFrame,
                                               proposedOffset: offset)
                    }
                    .onEnded { _ in
                        lastScale = scale
                        offset = clampedOffset(containerSize: containerSize,
                                               imageSize: imageFrame,
                                               proposedOffset: offset)
                        lastOffset = offset
                    }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if scale > minScale {
                            let proposed = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                            offset = clampedOffset(containerSize: containerSize,
                                                   imageSize: imageFrame,
                                                   proposedOffset: proposed)
                        }
                    }
                    .onEnded { _ in
                        lastOffset = offset
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation {
                    if scale > minScale {
                        scale = minScale
                        lastScale = minScale
                        offset = .zero
                        lastOffset = .zero
                    } else {
                        scale = 4.0
                        lastScale = 4.0
                        offset = clampedOffset(containerSize: containerSize,
                                               imageSize: imageFrame,
                                               proposedOffset: offset)
                        lastOffset = offset
                    }
                }
            }
    }

  /// Ограничивает смещение картинки так, чтобы её края не уходили за границы экрана
  /// - Parameters:
  ///   - containerSize: размер контейнера, в котором показывается картинка (обычно размер экрана)
  ///   - imageSize: фактический размер картинки на экране (после scaledToFit)
  ///   - proposedOffset: смещение, которое мы хотим применить (например, после drag или zoom)
  /// - Returns: скорректированное смещение, которое не позволяет картинке уходить за края
 
  //MARK: - clampedOffset
  private func clampedOffset(containerSize: CGSize, imageSize: CGSize, proposedOffset: CGSize) -> CGSize {
      
      // Рассчитываем размер картинки после масштабирования
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
      
        // Вычисляем максимально допустимое смещение по X и Y.
        // Если картинка меньше экрана, maxX/maxY = 0 (сдвиг не нужен)
        // Если картинка больше экрана, можно сдвигать не больше чем половина разницы
        let maxX = max((scaledWidth - containerSize.width) / 2, 0)
        let maxY = max((scaledHeight - containerSize.height) / 2, 0)
        
        // Ограничиваем предлагаемое смещение так, чтобы не выйти за maxX/maxY
        let clampedX = min(max(proposedOffset.width, -maxX), maxX)
        let clampedY = min(max(proposedOffset.height, -maxY), maxY)
        
        // Возвращаем скорректированное смещение
        return CGSize(width: clampedX, height: clampedY)
    }
  
}
