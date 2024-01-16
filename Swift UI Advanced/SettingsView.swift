//
//  SettingsView.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 05/01/2024.
//

import SwiftUI
import CoreData
import FirebaseAuth

struct SettingsView: View {
    @State private var editingNameTextField = false
    @State private var editingTwitterTextField = false
    @State private var editingSiteTextField = false
    @State private var editingBioTextField = false
    
    @State private var nameIconBounce = false
    @State private var twitterIconBounce = false
    @State private var siteIconBounce = false
    @State private var bioIconBounce = false
    
    @State private var name = ""
    @State private var twitter = ""
    @State private var site = ""
    @State private var bio = ""
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    @State
    private var showAlertView: Bool = false
    @State
    private var alertTitle: String = ""
    @State
    private var alertMessage: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], predicate: NSPredicate(format: "userID == %@", Auth.auth().currentUser!.uid), animation: .default) private var savedAccounts: FetchedResults<Account>
    @State private var currentAccount: Account?
    
    private let generator = UISelectionFeedbackGenerator()
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Settings")
                    .foregroundStyle(.white)
                    .font(.largeTitle.bold())
                    .padding(.top)
                Text("Manage your Design+Code profile and account")
                    .foregroundStyle(.white.opacity(0.7))
                    .font(.callout)
                
                // Choose Photo
                Button {
                    self.showImagePicker = true
                } label: {
                    HStack(spacing: 12) {
                        TextFieldIcon(iconName: "person.crop.circle", currentlyEditing: .constant(false), passedImage: $inputImage)
                        GradientText(text: "Choose Photo")
                        Spacer()
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    }
                    .background(Color.init(red: 26/255, green: 20/255, blue: 51/255).cornerRadius(16))
                }
                
                // Name TextField
                GradientTextField(editingTextField: $editingNameTextField, textFieldString: $name, iconBounce: $nameIconBounce, textFieldPlaceHolder: "Name", textFieldIconString: "textformat.alt")
                    .textInputAutocapitalization(.words)
                    .textContentType(.name)
                    .autocorrectionDisabled()
                // Twitter TextField
                GradientTextField(editingTextField: $editingTwitterTextField, textFieldString: $twitter, iconBounce: $twitterIconBounce, textFieldPlaceHolder: "Twitter Handle", textFieldIconString: "at")
                    .textInputAutocapitalization(.none)
                    .keyboardType(.twitter)
                    .autocorrectionDisabled()
                // Site TextField
                GradientTextField(editingTextField: $editingSiteTextField, textFieldString: $site, iconBounce: $siteIconBounce, textFieldPlaceHolder: "Website", textFieldIconString: "link")
                    .textInputAutocapitalization(.none)
                    .keyboardType(.webSearch)
                    .autocorrectionDisabled()
                // Bio TextField
                GradientTextField(editingTextField: $editingBioTextField, textFieldString: $bio, iconBounce: $bioIconBounce, textFieldPlaceHolder: "Bio", textFieldIconString: "text.justifyleft")
                    .textInputAutocapitalization(.sentences)
                    .keyboardType(.default)
                GradientButton(buttonTitle: "Save Settings") {
                    generator.selectionChanged()
                    currentAccount?.name = self.name
                    currentAccount?.bio = self.bio
                    currentAccount?.twitterHandle = self.twitter
                    currentAccount?.website = self.site
                    currentAccount?.profileImage = self.inputImage?.pngData()
                    do {
                        try viewContext.save()
                        // Present Alert
                        alertTitle = "Settings Saved"
                        alertMessage = "Your changes have been saved"
                        showAlertView.toggle()
                    } catch let error {
                        // Present Error
                        alertTitle = "Uh-Oh!"
                        alertMessage = error.localizedDescription
                        showAlertView.toggle()
                    }
                }
                Spacer()
            }
            .padding(.all)
            Spacer()
        }
        .background(Color("settingsBackground").ignoresSafeArea(edges: .all))
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(image: self.$inputImage)
        })
        .onAppear() {
            currentAccount = savedAccounts.first!
            self.name = currentAccount?.name ?? ""
            self.bio = currentAccount?.bio ?? ""
            self.twitter = currentAccount?.twitterHandle ?? ""
            self.site = currentAccount?.website ?? ""
            self.inputImage = UIImage(data: currentAccount?.profileImage ?? Data())
        }
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
        }
    }
}

#Preview {
    SettingsView()
}
