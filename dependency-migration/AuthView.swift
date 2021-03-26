//
//  AuthView.swift
//  dependency-migration
//
//  Created by Lee, Kyle on 3/25/21.
//

import Amplify
import SwiftUI

struct AuthView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.status)
            
            TextField("Username", text: $viewModel.username)
            TextField("Email", text: $viewModel.email)
            TextField("Confirmation Code", text: $viewModel.confirmationCode)
            
            Button("Check Session", action: viewModel.checkSession)
            Button("Sign Up", action: viewModel.signUp)
            Button("Confirm Email", action: viewModel.confirmEmail)
            Button("Login", action: viewModel.login)
            Button("Sign Out", action: viewModel.signOut)
        }
    }
    
}

extension AuthView {
    class ViewModel: ObservableObject {
        @Published var status = ""
        @Published var username = ""
        @Published var email = ""
        @Published var confirmationCode = ""
        
        let password = "password"
        
        func checkSession() {
            Amplify.Auth.fetchAuthSession { [weak self] result in
                let r = try! result.get()
                DispatchQueue.main.async {
                    self?.status = "Is signed in: \(r.isSignedIn)"
                }
            }
        }
        
        func signUp() {
            let emailAttribute = AuthUserAttribute(.email, value: email)
            let options = AuthSignUpRequest.Options(userAttributes: [emailAttribute])
            Amplify.Auth.signUp(username: username, password: password, options: options) { [weak self] result in
                let r = try! result.get()
                DispatchQueue.main.async {
                    self?.status = "Sign up complete: \(r.isSignupComplete)"
                }
            }
        }
        
        func confirmEmail() {
            Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { [weak self] result in
                let r = try! result.get()
                DispatchQueue.main.async {
                    self?.status = "Sign up complete: \(r.isSignupComplete)"
                }
            }
        }
        
        func login() {
            Amplify.Auth.signIn(username: username, password: password) { [weak self] result in
                let r = try! result.get()
                DispatchQueue.main.async {
                    self?.status = "Signed in: \(r.isSignedIn)"
                }
            }
        }
        
        func signOut() {
            Amplify.Auth.signOut { [weak self] _ in
                DispatchQueue.main.async {
                    self?.status = "Signed out"
                }
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
