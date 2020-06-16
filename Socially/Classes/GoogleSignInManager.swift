//
//  GoogleSignInManager.swift
//  Socially
//
//  Created by Phoe Lapyae on 16/06/2020.
//

import GoogleSignIn

public typealias GoogleSignInError = GIDSignInErrorCode
public typealias Google = GIDSignIn
public typealias GoogleUser = GIDGoogleUser
public typealias GoogleSignInHandler = (GIDSignIn?, GIDGoogleUser?, Error?) -> Void
public typealias GoogleAuthentication = GIDAuthentication

///This class signs the user in with Google.
public final class GoogleSignInManager {
    
    /// This is the instance of `GoogleSignInDelegate` that receives a refresh token or error after signing in.
    private var googleDelegate: GoogleSignInDelegate = GoogleSignInDelegate()
    
    /// This is the reference to Google shared instance.
    public var google: Google = Google.sharedInstance()
    
    /// This method is used for signing the user in. It means applying for a refresh token.
    public func signIn() {
        google.signIn()
    }
    
    /// This method is used for signing the user out. It means that current user is marked as being in sign out state.
    public func signOut() {
        google.signOut()
    }
    
    /// This method is used for disconnecting the user from the app. If the operation succeeds, the OAuth 2.0 token is also removed from keychain.
    public func disconnect() {
        google.disconnect()
    }
    
    /// This method is for setting client id.
    /// - Parameter resource: This is the name of `.plist` file that is downloaded from Google. `Make sure to add it in app bundle`.
    private func setUp(_ resource: String) {
        guard let path = Bundle.main.path(forResource: resource, ofType: "plist"), let googleInfo = NSDictionary(contentsOfFile: path), let clientID = googleInfo["CLIENT_ID"] as? String else {
            fatalError("\(resource).plist is not found.")
        }
        google.clientID = clientID
    }
    
    /// This method is used to set up `Google`'s delegate. Need to prepare and call it before `signIn()`, `restorePreviousSignIn()` and `disconnect() methods`
    /// - Parameters:
    ///   - signIn: This closure will be called at the end of the sign-in process. After signing the user in, it provides `a refresh token` that can be used for backend server (i.e. for later tasks) when it succeeds or `error` if it fails.
    ///   - disconnect: This closure will involve after disconnecting.
    public func delegateSignIn(signInCompletion signIn: @escaping GoogleSignInHandler, disconnectCompletion disconnect: @escaping GoogleSignInHandler = { _, _, _ in }) {
        googleDelegate.signInCompletion = signIn
        googleDelegate.disconnectCompletion = disconnect
        google.delegate = googleDelegate
    }
    
    /// This method should be called from your `UIApplicationDelegate`‘s `application(application:open:options)` method
    /// - Parameter url: The URL that was passed to the app.
    /// - Returns: `true` if `Google` handled this URL.
    public static func handle(_ url: URL?) -> Bool {
        Google.sharedInstance().handle(url)
    }
    
    /// This method will set the view controller for `SFSafariViewController`.
    /// - Parameter controller: This is the view controller used to present `SFSafariViewContoller` on iOS 9 and 10.
    public static func presentingViewController(_ controller: UIViewController?) {
        Google.sharedInstance().presentingViewController = controller
    }
    
    /// This is `init` method of `GoogleSignInManager` that will set up everything needed for Google sign-in.
    /// - Parameter resource: This is the name of `.plist` file that is downloaded from Google. `Make sure to add it in app bundle`.
    public init(_ resource: String) {
        setUp(resource)
    }
    
    /// This method will restore previous authenticated token if `hasPreviousSignIn` is true.
    public func restorePreviousSignIn() {
        google.restorePreviousSignIn()
    }
    
    /// This will check whether a previous authenticated token. If it has, return `true`.
    public var hasPreviousSignIn: Bool {
        google.hasPreviousSignIn()
    }
    
}

/// This class is the delegate of `Google`
fileprivate final class GoogleSignInDelegate: NSObject, GIDSignInDelegate {
    
    /// This closure will perform after signing the user in.
    var signInCompletion: GoogleSignInHandler?
    
    /// This closure will perform after disconnecting.
    var disconnectCompletion: GoogleSignInHandler?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        signInCompletion?(signIn, user, error)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        disconnectCompletion?(signIn, user, error)
    }
}
