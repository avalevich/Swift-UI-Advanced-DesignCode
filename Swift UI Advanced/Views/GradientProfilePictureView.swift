//
//  GradientProfilePictureView.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 05/01/2024.
//

import SwiftUI

struct GradientProfilePictureView: View {
    @State
    private var angle = 0.0
    var gradient: [Color] = [
        Color.init(red: 101/255, green: 134/255, blue: 1),
        Color.init(red: 1, green: 64/255, blue: 80/255),
        Color.init(red: 109/255, green: 1, blue: 185/255),
        Color.init(red: 39/255, green: 232/255, blue: 1)
    ]
    var profilePicture: UIImage
    
    var body: some View {
        ZStack {
            AngularGradient.init(gradient: Gradient(colors: gradient), center: .center, angle: .degrees(angle))
                .mask {
                    Circle()
                        .frame(width: 70, height: 70, alignment: .center)
                        .blur(radius: 8)
                }
                .blur(radius: 8)
                .onAppear() {
                    withAnimation(.linear(duration: 7)) {
                        self.angle += 360
                    }
                }
            Image(uiImage: profilePicture)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 66, height: 66, alignment: .center)
                .mask(Circle())
        }
    }
}

#Preview {
    GradientProfilePictureView(profilePicture: UIImage(named: "Profile")!)
}
