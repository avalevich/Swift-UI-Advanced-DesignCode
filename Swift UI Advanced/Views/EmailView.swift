//
//  EmailView.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 16/01/2024.
//

import SwiftUI

final class EmailViewModel: ObservableObject {
    @Published var emailIconBounce: Bool = false
    @Binding var editingEmailTextField: Bool
    @Binding var editingPasswordTextField: Bool
    @Binding var email: String
    
    init(emailIconBounce: Bool, editingEmailTextField: Binding<Bool>, editingPasswordTextField: Binding<Bool>, email: Binding<String>) {
        self.emailIconBounce = emailIconBounce
        self._editingEmailTextField = editingEmailTextField
        self._editingPasswordTextField = editingPasswordTextField
        self._email = email
    }
}

struct EmailView: View {
    @ObservedObject private var viewModel: EmailViewModel
    private let generator = UISelectionFeedbackGenerator()
    
    init(viewModel: EmailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(spacing: 12) {
            TextFieldIcon(iconName: "envelope.open.fill", currentlyEditing: viewModel.$editingEmailTextField, passedImage: .constant(nil))
                .scaleEffect(viewModel.emailIconBounce ? 1.2 : 1.0)
            TextField("Email", text: viewModel.$email) {  isEditing in
                viewModel.editingEmailTextField = isEditing
                viewModel.editingPasswordTextField = false
                generator.selectionChanged()
                if isEditing {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                        viewModel.emailIconBounce.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                            viewModel.emailIconBounce.toggle()
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
            .foregroundStyle(.white.opacity(0.7))
            .textInputAutocapitalization(.never)
            .textContentType(.emailAddress)
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
    EmailView(viewModel: EmailViewModel(emailIconBounce: false, editingEmailTextField: .constant(false), editingPasswordTextField: .constant(false), email: .constant("email@text.com")))
}
