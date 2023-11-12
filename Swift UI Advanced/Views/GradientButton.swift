//
//  GradientButton.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 03/11/2023.
//

import SwiftUI

struct GradientButton: View {
    @State
    private var angle = 0.0
    var gradient: [Color] = [
        Color.init(red: 101/255, green: 134/255, blue: 1),
        Color.init(red: 1, green: 64/255, blue: 80/255),
        Color.init(red: 109/255, green: 1, blue: 185/255),
        Color.init(red: 39/255, green: 232/255, blue: 1)
    ]
    var buttonTitle: String
    var buttonAction: () -> Void
    var body: some View {
        Button {
            buttonAction()
        } label: {
            GeometryReader { geo in
                ZStack {
                    AngularGradient(gradient: Gradient(colors: gradient), center: .center, angle: .degrees(angle))
                        .blendMode(.overlay)
                        .blur(radius: 8.0)
                        .mask {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(height: 50)
                                .frame(maxWidth: geo.size.width - 16)
                                .blur(radius: 8)
                        }
                        .onAppear() {
                            withAnimation(.linear(duration: 7)) {
                                self.angle += 350
                            }
                        }
                    GradientText(text: buttonTitle)
                        .font(.headline)
                        .frame(width: geo.size.width - 16)
                        .frame(height: 50)
                        .background {
                            Color("tertiaryBackground")
                                .opacity(0.9)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 1.9)
                                .blendMode(.normal)
                                .opacity(0.7)
                        }
                        .cornerRadius(16)
                }
            }
            .frame(height: 50)
        }
    }
}
