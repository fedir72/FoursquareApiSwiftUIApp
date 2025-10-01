//
//  MarqueeText.swift
//  FoursquareAppSwiftUI
//
//  Created by ihor fedii on 21.09.25.
//

import SwiftUI


//MARK: - view with moving text
struct MarqueeText: View {
    let text: String
    let font: Font
    let speed: Double // пикселей в секунду

    @State private var textWidth: CGFloat? = nil
    @State private var containerWidth: CGFloat? = nil
    @State private var offset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Text(text)
                    .font(font)
                    .offset(x: offset)
                
                // Дублируем текст для плавной бесконечной прокрутки
                if let textWidth, let containerWidth, textWidth > containerWidth {
                    Text(text)
                        .font(font)
                        .offset(x: offset + textWidth + 50)
                }
            }
            .clipped()
            .background(
                Color.clear
                    .onAppear {
                        DispatchQueue.main.async {
                            textWidth = geo.size.width
                            containerWidth = geo.size.width
                            startAnimation()
                        }
                    }
            )
        }
        .frame(height: 20)
    }

    private func startAnimation() {
        guard let textWidth, let containerWidth, textWidth > containerWidth else { return }
        offset = 0
        let distance = textWidth + 50
        let duration = distance / speed
        withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
            offset = -distance
        }
    }
}
