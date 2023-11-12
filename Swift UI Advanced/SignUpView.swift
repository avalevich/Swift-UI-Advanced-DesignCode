//
//  ContentView.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 03/11/2023.
//

import SwiftUI
import AudioToolbox
import FirebaseAuth

struct SignUpView: View {
    @State
    private var email: String = ""
    @State
    private var password: String = ""
    @State
    private var editingEmailTextField: Bool = false
    @State
    private var editingPasswordTextField: Bool = false
    @State
    private var emailIconBounce: Bool = false
    @State
    private var passwordIconBounce: Bool = false
    @State
    private var showProfileView: Bool = false
    @State
    private var showSignUp: Bool = true
    @State
    private var rotationAngle = 0.0
    @FocusState
    private var isPasswordFieldInFocus: Bool
    
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Image(showSignUp ? "background-3": "background-1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(showSignUp ? "Sign Up": "Sign In")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    Text("Access to 120+ hours of courses, tutorials, and livestreams")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                    HStack(spacing: 12) {
                        TextFieldIcon(iconName: "envelope.open.fill", currentlyEditing: $editingEmailTextField)
                            .scaleEffect(emailIconBounce ? 1.2 : 1.0)
                        TextField("Email", text: $email) {  isEditing in
                            editingEmailTextField = isEditing
                            editingPasswordTextField = false
                            generator.selectionChanged()
                            if isEditing {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                    emailIconBounce.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                        emailIconBounce.toggle()
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
                    
                    HStack(spacing: 12) {
                        TextFieldIcon(iconName: "key.fill", currentlyEditing: $editingPasswordTextField)
                            .scaleEffect(passwordIconBounce ? 1.2 : 1.0)
                        SecureField("Password", text: $password)
                            .preferredColorScheme(.dark)
                            .foregroundStyle(.white.opacity(0.7))
                            .textInputAutocapitalization(.never)
                            .textContentType(.password)
                            .focused($isPasswordFieldInFocus)
                            .onChange(of: isPasswordFieldInFocus) { _, isFocused in
                                editingPasswordTextField = isFocused
                                if isFocused {
                                    editingEmailTextField = false
                                }
                                generator.selectionChanged()
                                if isFocused {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                        passwordIconBounce.toggle()
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                                            passwordIconBounce.toggle()
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
                    GradientButton(buttonTitle: showSignUp ? "Create account": "Sign In") {
                        generator.selectionChanged()
                        signUp()
                    }.onAppear {
                        Auth.auth().addStateDidChangeListener { auth, user in
                            if user != nil {
                                showProfileView.toggle()
                            }
                        }
                    }
                    if showSignUp {
                        Text("By clicking on Sign up, you agree to our Terms of service and Privacy policy")
                            .font(.footnote)
                            .foregroundStyle(Color.white.opacity(0.7))
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.white.opacity(0.1))
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.7)) {
                                showSignUp.toggle()
                                self.rotationAngle += 180
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(showSignUp ? "Already have an account?": "Don't have an account?")
                                    .font(.footnote)
                                    .foregroundStyle(Color.white.opacity(0.7))
                                GradientText(text: showSignUp ? "Sign In": "Sign Up")
                                    .font(.footnote.bold())
                            }
                        }
                        if !showSignUp {
                            Button {
                                print("send reset password email")
                            } label: {
                                HStack(spacing: 4) {
                                    Text("Forgot password?")
                                        .font(.footnote)
                                        .foregroundStyle(Color.white.opacity(0.7))
                                    GradientText(text: "Reset password")
                                        .font(.footnote.bold())
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                .padding(20)
            }
            .rotation3DEffect(
                Angle(degrees: self.rotationAngle),
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .systemThinMaterialDark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            )
            .cornerRadius(30)
            .padding(.horizontal)
            .rotation3DEffect(
                Angle(degrees: self.rotationAngle),
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
        }
        //        .fullScreenCover(isPresented: $showProfileView) {
        //            ProfileView()
        //        }
    }
    
    func signUp() {
        if showSignUp {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                guard error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                print("User signed up")
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                print("User signed in")
            }
        }
    }
}

#Preview {
    SignUpView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
