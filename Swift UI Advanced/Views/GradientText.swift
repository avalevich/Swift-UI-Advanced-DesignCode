//
//  GradientText.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 03/11/2023.
//

import SwiftUI

struct GradientText: View {
    private var text: String = "Text here"
    init(text: String) {
        self.text = text
    }
    var body: some View {
        Text(text)
            .gradientForeground(colors: [Color("pink-gradient-1"), Color("pink-gradient-2")])
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay {
            LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
            .mask(self)
        }
    }
}
