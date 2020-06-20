//
//  FacebookSignInManager.swift
//  Socially
//
//  Created by Phoe Lapyae on 17/06/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

public class Facebook {
    public static func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    public static func application(openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
    
    public static var accessToken: AccessToken? {
        AccessToken.current
    }
    
    public static var loginManager: LoginManager = LoginManager()
    
    public static func logIn() {
        loginManager.logIn(permissions: Facebook.permissions, viewController: nil, completion: completion)
    }
    
    public static func logOut() {
        loginManager.logOut()
        signOutCompletion?()
        KeyChain.delete()
    }
    
    public static func restore() {
        guard let token = AccessToken.current, !token.isExpired else {
            print("Expired")
            return
        }
        completion(.success(granted: token.permissions, declined: token.declinedPermissions, token: token))
    }
    
    public static func reauthorizeDataAccess() {
        loginManager.reauthorizeDataAccess(from: UIApplication.shared.windows.first!.rootViewController!) { (result, error) in
            completion(Facebook.toLoginResult(result: result, error: error))
        }
    }
    
    static var signInCompletion: LoginResultBlock? = nil
    static var signOutCompletion: (() -> Void)? = nil
    static var permissions: [Permission] = [.publicProfile]
    
    internal static func completion(_ result: LoginResult) {
        signInCompletion?(result)
        switch result {
        case .success(granted: _, declined: _, token: _):
            KeyChain.save(.facebook)
        default:
            return
        }
    }
    
    public static func addPermission(permissions: [Permission]) {
        Facebook.permissions.append(contentsOf: permissions)
    }
    
    internal static func toLoginResult(result: LoginManagerLoginResult?, error: Error?) -> LoginResult {
        guard let result = result, error == nil else {
          return .failed(error ?? LoginError(.unknown))
        }

        guard !result.isCancelled, let token = result.token else {
          return .cancelled
        }

        let granted: Set<Permission> = Set(result.grantedPermissions.map { Permission(stringLiteral: $0) })
        let declined: Set<Permission> = Set(result.declinedPermissions.map { Permission(stringLiteral: $0) })
        return .success(granted: granted, declined: declined, token: token)
    }
}

public extension SociallyAuth {
    static func setFacebookProvider(afterSignIn signIn: @escaping LoginResultBlock = { _ in }, afterSignOut signOut: @escaping (() -> Void) = { }) {
        Facebook.signInCompletion = signIn
        Facebook.signOutCompletion = signOut
        socials[.facebook] = SignInProcess(Facebook.logIn, Facebook.logOut, Facebook.restore)
    }
}
