//
//  SociallyAuth.swift
//  Socially
//
//  Created by Phoe Lapyae on 18/06/2020.
//  Copyright © 2020 Phoe Lapyae. All rights reserved.
//

import Foundation

public enum Social: String, Codable {
    case google, facebook
    public var name: String {
        switch self {
        case .google:
            return "Google"
        case .facebook:
            return "Facebook"
        }
    }
}

public class SociallyAuth: ObservableObject {
    static var socials: [Social: SignInProcess] = [:]
    
    public static func signIn(with social: Social) {
        guard let process = socials[social] else {
            print("Warning: You need to set \(social.name) Provider.")
            return
        }
        process.signIn()
    }
    
    public static func signOut() {
        guard let social = KeyChain.load() else {
            print("Bug: Cannot load keychain")
            return
        }
        guard let process = socials[social] else {
            print("Bug: Cannot sign out.")
            return
        }
        process.signOut()
    }
    
    public static func restore() {
        guard let social = KeyChain.load() else {
            return
        }
        guard let process = socials[social] else {
            print("Bug: Cannot restore.")
            return
        }
        process.restore()
    }
}

public class SignInProcess {
    var signIn: (() -> Void)
    var signOut: (() -> Void)
    var restore: (() -> Void)
    init(_ signIn: @escaping (() -> Void), _ signOut: @escaping (() -> Void), _ restore: @escaping (() -> Void)) {
        self.signIn = signIn
        self.signOut = signOut
        self.restore = restore
    }
}
