//
//  PasswordView.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 16/01/2024.
//

import SwiftUI

final class PasswordViewModel: ObservableObject {
    @Published var passwordIconBounce: Bool = false
    @Binding var editingEmailTextField: Bool
    @Binding var editingPasswordTextField: Bool
    @Binding var password: String
    
    init(passwordIconBounce: Bool, editingEmailTextField: Binding<Bool>, editingPasswordTextField: Binding<Bool>, password: Binding<String>) {
        self.passwordIconBounce = passwordIconBounce
        self._editingEmailTextField = editingEmailTextField
        self._editingPasswordTextField = editingPasswordTextField
        self._password = password
    }
}

struct PasswordView: View {
    @ObservedObject private var viewModel: PasswordViewModel
    @FocusState private var isPasswordFieldInFocus: Bool
    private let generator = UISelectionFeedbackGenerator()
    
    init(viewModel: PasswordViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        HStack(spacing: 12) {
            TextFieldIcon(iconName: "key.fill", currentlyEditing: viewModel.$editingPasswordTextField, passedImage: .constant(nil))
                .scaleEffect(viewModel.passwordIconBounce ? 1.2 : 1.0)
            SecureField("Password", text: viewModel.$password)
                .preferredColorScheme(.dark)
                .foregroundStyle(.white.opacity(0.7))
                .textInputAutocapitalization(.never)
                .textContentType(.password)
                .focused($isPasswordFieldInFocus)
                .onChange(of: isPasswordFieldInFocus) { _, isFocused in
                    viewModel.editingPasswordTextField = isFocused
                    if isFocused {
                        viewModel.editingEmailTextField = false
                    }
                    generator.selectionChanged()
                    if isFocused {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                            viewModel.passwordIconBounce.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                viewModel.passwordIconBounce.toggle()
                            }
                        }
                    }
                }
        }
        .frame(height: 52)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 1)
                .blendMode(.overlay)
        }
        .background {
            Color("secondaryBackground")
                .cornerRadius(16)
                .opacity(0.8)
        }
    }
}

#Preview {
    PasswordView(viewModel: PasswordViewModel(passwordIconBounce: false, editingEmailTextField: .constant(false), editingPasswordTextField: .constant(false), password: .constant("secret")))
}
