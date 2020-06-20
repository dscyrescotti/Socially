//
//  GoogleSignInManager.swift
//  Socially
//
//  Created by Phoe Lapyae on 16/06/2020.
//  Copyright © 2020 Phoe Lapyae. All rights reserved.
//

import GoogleSignIn

public final class Google {
    
    private static var delegate: GoogleSignInDelegate = GoogleSignInDelegate()
    
    fileprivate static func handleCompletion(signIn: @escaping ((GIDSignIn?, GIDGoogleUser?, Error?) -> Void), disconnect: @escaping ((GIDSignIn?, GIDGoogleUser?, Error?) -> Void)) {
        delegate.signInCompletion = signIn
        delegate.disconnectCompletion = disconnect
    }
    
    public static func signIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    public static func signOut() {
        GIDSignIn.sharedInstance().signOut()
        
    }
    
    public static func disconnect() {
        GIDSignIn.sharedInstance().disconnect()
    }
    
    fileprivate static func setUp() {
        guard let path = Bundle.main.path(forResource: "credentials", ofType: "plist"), let googleInfo = NSDictionary(contentsOfFile: path), let clientID = googleInfo["CLIENT_ID"] as? String else {
            fatalError("Make sure to rename .plist file to \"credentials\" and add it to the app bundle.")
        }
        GIDSignIn.sharedInstance().clientID = clientID
        GIDSignIn.sharedInstance().delegate = Google.delegate
    }
    
    public static func handle(_ url: URL?) -> Bool {
        GIDSignIn.sharedInstance().handle(url)
    }
    
    public static func presentingViewController(_ controller: UIViewController?) {
        GIDSignIn.sharedInstance().presentingViewController = controller
    }
    
    public static func restorePreviousSignIn() {
        if hasPreviousSignIn {
            GIDSignIn.sharedInstance().restorePreviousSignIn()
        }
    }
    
    public static var hasPreviousSignIn: Bool {
        GIDSignIn.sharedInstance().hasPreviousSignIn()
    }
    
    public static var currentUser: GIDGoogleUser? {
        GIDSignIn.sharedInstance().currentUser
    }
    
    public static var sharedInstance: GIDSignIn {
        GIDSignIn.sharedInstance()
    }
    
}

fileprivate final class GoogleSignInDelegate: NSObject, GIDSignInDelegate {
    
    var signInCompletion: ((GIDSignIn?, GIDGoogleUser?, Error?) -> Void)?
    
    var disconnectCompletion: ((GIDSignIn?, GIDGoogleUser?, Error?) -> Void)?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        signInCompletion?(signIn, user, error)
        if error == nil {
            KeyChain.save(.google)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        disconnectCompletion?(signIn, user, error)
        if error == nil {
            KeyChain.delete()
        }
    }
}

public extension SociallyAuth {
    static func setGoogleProvider(afterSignIn signIn: @escaping ((GIDSignIn?, GIDGoogleUser?, Error?) -> Void) = { _,_,_ in }, afterDisconnect disconnect: @escaping ((GIDSignIn?, GIDGoogleUser?, Error?) -> Void) = { _,_,_ in }) {
        Google.handleCompletion(signIn: signIn, disconnect: disconnect)
        Google.setUp()
        socials[.google] = SignInProcess(Google.signIn, Google.disconnect, Google.restorePreviousSignIn)
    }
}
