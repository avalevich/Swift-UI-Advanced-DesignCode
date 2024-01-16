//
//  gradientTextField.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 05/01/2024.
//

import SwiftUI

struct GradientTextField: View {
    @Binding var editingTextField: Bool
    @Binding var textFieldString: String
    @Binding var iconBounce: Bool
    var textFieldPlaceHolder: String
    var textFieldIconString: String
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack(spacing: 12) {
            TextFieldIcon(iconName: textFieldIconString, currentlyEditing: $editingTextField, passedImage: .constant(nil))
                .scaleEffect(iconBounce ? 1.2 : 1.0)
            TextField(textFieldPlaceHolder, text: $textFieldString) { isEditing in
                editingTextField = isEditing
                generator.selectionChanged()
                if isEditing {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                        iconBounce.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                            iconBounce.toggle()
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
            .foregroundStyle(.white.opacity(0.7))
            .textInputAutocapitalization(.never)
            .textContentType(.emailAddress)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 1)
                .blendMode(.overlay)
        }
        .background(
            Color(red: 26/255, green: 20/255, blue: 51/255)
                .cornerRadius(16)
        )
    }
}

#Preview {
    GradientTextField(
        editingTextField: .constant(
            true
        ),
        textFieldString: .constant(
            "Some string here"
        ),
        iconBounce: .constant(
            false
        ),
        textFieldPlaceHolder: "TextField",
        textFieldIconString: "textformat.alt"
    )
}
