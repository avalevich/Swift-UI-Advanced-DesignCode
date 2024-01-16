//
//  ContentView.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 03/11/2023.
//

import SwiftUI
import AudioToolbox
import FirebaseAuth

final class SignUpViewModel: ObservableObject {
    @Published var emailIconBounce: Bool = false
    @Published var passwordIconBounce: Bool = false
    @Binding var showAlertView: Bool
    @Binding var showSignUp: Bool
    @Binding var email: String
    @Binding var password: String
    @Binding var alertTitle: String
    @Binding var alertMessage: String
    
    
    init(showSignUp: Binding<Bool>, email: Binding<String>, password: Binding<String>, showAlertView: Binding<Bool>, alertTitle: Binding<String>, alertMessage: Binding<String>) {
        self._showSignUp = showSignUp
        self._email = email
        self._password = password
        self._showAlertView = showAlertView
        self._alertTitle = alertTitle
        self._alertMessage = alertMessage
    }
    
    func signUp() {
        if showSignUp {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                guard error == nil else {
                    self.alertTitle = "Uh-oh!"
                    self.alertMessage = error!.localizedDescription
                    self.showAlertView.toggle()
                    return
                }
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard error == nil else {
                    self.alertTitle = "Uh-oh!"
                    self.alertMessage = error!.localizedDescription
                    self.showAlertView.toggle()
                    return
                }
            }
        }
    }
    
    func sendPasswordResetEmail() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                self.alertTitle = "Uh-oh!"
                self.alertMessage = error!.localizedDescription
                self.showAlertView.toggle()
                return
            }
            self.alertTitle = "Password reset email sent"
            self.alertMessage = "Check your inbox for an email to reset your password."
            self.showAlertView.toggle()
        }
    }
}

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    @State var editingEmailTextField: Bool = false
    @State var editingPasswordTextField: Bool = false
    
    @State private var showProfileView: Bool = false
    @State private var rotationAngle = 0.0
    @State private var signInWithAppleObject = SignInWithAppleObject()
    @State private var fadeToggle: Bool = true
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)],  animation: .default) var savedAccounts: FetchedResults<Account>
    
    private let generator = UISelectionFeedbackGenerator()
    
    private var emailView: some View {
        EmailView(viewModel:
            EmailViewModel(
                emailIconBounce: viewModel.emailIconBounce,
                editingEmailTextField: $editingEmailTextField,
                editingPasswordTextField: $editingPasswordTextField,
                email: viewModel.$email
            )
        )
    }
    
    private var passwordView: some View {
        PasswordView(viewModel:
            PasswordViewModel(
                passwordIconBounce: viewModel.passwordIconBounce,
                editingEmailTextField: $editingEmailTextField,
                editingPasswordTextField: $editingPasswordTextField,
                password: viewModel.$password
            )
        )
    }
    
    init(showSignUp: Binding<Bool>, email: Binding<String>, password: Binding<String>, showAlertView: Binding<Bool>, alertTitle: Binding<String>, alertMessage: Binding<String>) {
        self.viewModel = SignUpViewModel(showSignUp: showSignUp, email: email, password: password, showAlertView: showAlertView, alertTitle: alertTitle, alertMessage: alertMessage)
    }
    
    var body: some View {
        ZStack {
            Image(viewModel.showSignUp ? "background-3": "background-1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 1.0 : 0.0)
            Color("secondaryBackground")
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 0.0 : 1.0)
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.showSignUp ? "Sign Up": "Sign In")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    Text("Access to 120+ hours of courses, tutorials, and livestreams")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                    emailView
                    passwordView
                    GradientButton(buttonTitle: viewModel.showSignUp ? "Create account": "Sign In") {
                        generator.selectionChanged()
                        viewModel.signUp()
                    }.onAppear {
                        Auth.auth().addStateDidChangeListener { auth, user in
                            if let currentUser = user {
                                if savedAccounts.count == 0 {
                                    // Add data to CoreData
                                    let userDataToSave = Account(context: viewContext)
                                    userDataToSave.name = currentUser.displayName
                                    userDataToSave.bio = nil
                                    userDataToSave.userID = currentUser.uid
                                    userDataToSave.numberOfCertificates = 0
                                    userDataToSave.proMember = false
                                    userDataToSave.twitterHandle = nil
                                    userDataToSave.website = nil
                                    userDataToSave.profileImage = nil
                                    userDataToSave.userSince = Date()
                                    do {
                                        try viewContext.save()
                                        DispatchQueue.main.async {
                                            showProfileView.toggle()
                                        }
                                    } catch let error {
                                        viewModel.alertTitle = "Could not create an account"
                                        viewModel.alertMessage = error.localizedDescription
                                        viewModel.showAlertView.toggle()
                                    }
                                } else {
                                    showProfileView.toggle()
                                }
                            }
                        }
                    }
                    if viewModel.showSignUp {
                        Text("By clicking on Sign up, you agree to our Terms of service and Privacy policy")
                            .font(.footnote)
                            .foregroundStyle(Color.white.opacity(0.7))
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.white.opacity(0.1))
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                fadeToggle.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                    withAnimation(.easeInOut(duration: 0.35)) {
                                        self.fadeToggle.toggle()
                                    }
                                }
                            }
                            withAnimation(.easeInOut(duration: 0.7)) {
                                viewModel.showSignUp.toggle()
                                self.rotationAngle += 180
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(viewModel.showSignUp ? "Already have an account?": "Don't have an account?")
                                    .font(.footnote)
                                    .foregroundStyle(Color.white.opacity(0.7))
                                GradientText(text: viewModel.showSignUp ? "Sign In": "Sign Up")
                                    .font(.footnote.bold())
                            }
                        }
                        if !viewModel.showSignUp {
                            Button {
                                viewModel.sendPasswordResetEmail()
                            } label: {
                                HStack(spacing: 4) {
                                    Text("Forgot password?")
                                        .font(.footnote)
                                        .foregroundStyle(Color.white.opacity(0.7))
                                    GradientText(text: "Reset password")
                                        .font(.footnote.bold())
                                }
                            }
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.white.opacity(0.1))
                            Button {
                                signInWithAppleObject.signInWithApple()
                            } label: {
                                SignInWithAppleButton()
                                    .frame(height: 50)
                                    .cornerRadius(16)
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
            .alert(isPresented: viewModel.$showAlertView) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .cancel())
            }
        }
        .animation(.easeInOut(duration: 0.7), value: viewModel.showSignUp)
        .fullScreenCover(isPresented: $showProfileView) {
            ProfileView()
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
}

#Preview {
    SignUpView(
        showSignUp: .constant(true),
        email: .constant("email@test.com"),
        password: .constant("secret"),
        showAlertView: .constant(false),
        alertTitle: .constant(""),
        alertMessage: .constant("")
    ).environment(
        \.managedObjectContext,
         PersistenceController.shared.container.viewContext
    )
}
