//
//  SignInManager.swift
//  SociallyDemo
//
//  Created by Phoe Lapyae on 16/06/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Socially

class SignInManager: ObservableObject {
    let googleManager = GoogleSignInManager("credentials")
    @Published var user: User?
    func signIn() {
        googleManager.signIn()
    }
    func signOut() {
        googleManager.disconnect()
    }
    func restore() {
        googleManager.restorePreviousSignIn()
    }
    init() {
        googleManager.delegateSignIn(signInCompletion: { google, user, error in
            if let error = error {
                if (error as NSError).code == GoogleSignInError.hasNoAuthInKeychain.rawValue {
                    print("The user has not signed in before or they have since signed out.")
                } else {
                    print("\(error.localizedDescription)")
                }
                return
            }
            guard let user = user, let profile = user.profile else { return }
            self.user = User(name: profile.name, email: profile.email)
            
            print("Sign In")
            print(user.authentication.accessToken as String)
            print(user.authentication.accessTokenExpirationDate as Date)
        }) { _, _, _ in
            self.user = nil
        }
    }
}

struct User {
    var name: String
    var email: String
}
