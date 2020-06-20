//
//  SignInManager.swift
//  SociallyDemo
//
//  Created by Phoe Lapyae on 16/06/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Socially
import GoogleSignIn
import FBSDKLoginKit

class SignInManager: ObservableObject {
    @Published var user: User?
    
    static let sharedInstance: SignInManager = SignInManager()
    
    init() {
        googleSetup()
        facebookSetup()
    }
    
    private func googleSetup() {
        SociallyAuth.setGoogleProvider(afterSignIn: { (googleSignIn, googleUser, error) in
            if let error = error {
              if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
              } else {
                print("\(error.localizedDescription)")
              }
              return
            }
            guard let profile = googleUser?.profile else { return }
            self.user = User(name: profile.name, email: profile.email, firstName: profile.givenName, lastName: profile.familyName)
        }) { _, _, _ in
            self.user = nil
        }
    }
    
    private func facebookSetup() {
        SociallyAuth.setFacebookProvider(afterSignIn: { result in
            switch result {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("User cancelled login.")
            case .success(_,_,_):
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start { (connection, result, error) in
                    if (error == nil) {
                        let details = result as! NSDictionary
                        self.user = User(name:
                            details.object(forKey: "name") as! String, email: details.object(forKey: "email") as! String, firstName: details.object(forKey: "first_name") as! String, lastName: details.object(forKey: "last_name") as! String)
                    }
                }
            }
        }) {
            self.user = nil
        }
    }
}

struct User {
    var name: String
    var email: String
    var firstName: String
    var lastName: String
}
