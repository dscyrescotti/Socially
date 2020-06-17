//
//  FacebookSignInManager.swift
//  Socially
//
//  Created by Phoe Lapyae on 17/06/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

typealias Facebook = LoginManager
typealias FacebookLoginCompletion = LoginResultBlock
typealias FacebookLoginHandler = LoginManagerLoginResultBlock
typealias FacebookAccessToken = AccessToken
typealias FacebookGraphAPI = GraphRequest

class FacebookLogInManager {
    
    /// This method should be called inside `application(_:didFinishLaunchingWithOptions:)` of `AppDelegate`. It should be invoked for the proper use of the Facebook SDK. As part of SDK initialization basic auto logging of app events will occur, this can becontrolled via 'FacebookAutoLogAppEventsEnabled' key in the project info plist file.
    /// - Parameters:
    ///   - application:
    ///   - launchOptions:
    static func setUp(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /// This method should be called inside `application(_:open:options:)` of `AppDelegate`. It should be invoked for the proper processing of responses during interaction with the native Facebook app or Safari as part of SSO authorization flow or Facebook dialogs.
    /// - Parameters:
    ///   - app:
    ///   - url:
    ///   - options:
    /// - Returns: `true` if the url was intended for the Facebook SDK, `false` if not.
    static func handle(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    ///  This method should be called inside `scene(_:openURLContexts:)` of `SceneDelegate`. It should be invoked for the proper processing of responses during interaction with the native Facebook app or Safari as part of SSO authorization flow or Facebook dialogs.
    /// - Parameter URLContexts:
    static func scene(openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
    
    /// This is the refrence to Facebook access token. (aka `AccessToken`)
    var accessToken: FacebookAccessToken? {
        FacebookAccessToken.current
    }
    
    /// This is the instance of the Facebook login manager. Its purpose is to handle login and logout to Facebook. (aka `LoginManager`)
    var facebook: Facebook = Facebook()
    
    /// This method is used to log the user in.
    /// - Parameters:
    ///   - permissions: This is required for a Graph API read permission. Each permission has its own set of requirements and suggested use cases. See a full list at https://developers.facebook.com/docs/facebook-login/permissions
    ///   - viewController: Optional view controller to present from. Default: topmost view controller.
    ///   - completion: This closure will called at the end of the login process. After logging the user in, it provides `a refresh token` that can be used for backend server (i.e. for later tasks) when it succeeds or `error` if it fails. Retrieving Facebook GraphAPI data should be set inside this closure.
    func logIn(permissions: [Permission] = [.publicProfile], from viewController: UIViewController? = nil, completion: FacebookLoginCompletion? = nil) {
        facebook.logIn(permissions: permissions, viewController: viewController, completion: completion)
    }
    
    /// This method is used to log the user in.
    /// - Parameters:
    ///   - permissions: This is required for a Graph API read permission. Each permission has its own set of requirements and suggested use cases. See a full list at https://developers.facebook.com/docs/facebook-login/permissions
    ///   - viewController: Optional view controller to present                                           from. Default: topmost view controller.
    ///   - handler: This closure will called at the end of the login process. After logging the user in, it provides `a refresh token` that can be used for backend server (i.e. for later tasks) when it succeeds or `error` if it fails. Retrieving Facebook GraphAPI data should be set inside this closure.
    func logIn(permissions: [String], from viewController: UIViewController? = nil, handler: FacebookLoginHandler? = nil) {
        facebook.logIn(permissions: permissions, from: viewController, handler: handler)
    }
    
    /// This method is used to log the user out.
    func logOut() {
        facebook.logOut()
    }
    
    /// This method is used to reauthorize application's data access, after it has expired due to inactivity.
    /// - Parameter handler: This clousre will called at the end of the process.
    func reauthorizeDataAccess(handler: @escaping FacebookLoginHandler) {
        facebook.reauthorizeDataAccess(from: UIApplication.shared.windows.first!.rootViewController!, handler: handler)
    }
    
    /// This method is used to connect the Facebook GraphAPI. It will initialize the new instance and return it.
    /// - Parameters:
    ///   - graphPath: The graph path (e.g., @"me").
    ///   - parameters: The optional parameters.
    ///   - tokenString: The token string to use. Specifying nil will cause no token to be used..
    ///   - version: The optional Graph API version (e.g., "v2.0"). nil defaults to `[FBSDKSettings graphAPIVersion]`.
    ///   - httpMethod: The HTTP method. Empty String defaults to `.get`.
    /// - Returns: The instance of `FacebookGraphAPI` (aka `GraphRequest`)
    @discardableResult
    func graphAPI(graphPath: String, parameters: [String : Any] = [:], tokenString: String? = nil, version: String? = nil, httpMethod: HTTPMethod = .get) -> FacebookGraphAPI {
        FacebookGraphAPI(graphPath: graphPath, parameters: parameters, tokenString: tokenString, version: version, httpMethod: httpMethod)
    }
    
    /// This method is used to connect the Facebook GraphAPI. It will initialize the new instance and return it.
    /// - Parameters:
    ///   - graphPath: The graph path (e.g., @"me").
    ///   - parameters: The optional parameters.
    /// - Returns: The instance of `FacebookGraphAPI` (aka `GraphRequest`)
    @discardableResult
    func graphAPI(graphPath: String, parameters: [String : Any] = [:]) -> FacebookGraphAPI {
        FacebookGraphAPI(graphPath: graphPath, parameters: parameters)
    }
    
}

