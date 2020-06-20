//
//  KeyChain.swift
//  Socially
//
//  Created by Phoe Lapyae on 20/06/2020.
//  Copyright © 2020 Phoe Lapyae. All rights reserved.
//

import Foundation

class KeyChain {
    
    static let key: String = "Socially-SocialKey"

    private class func save(data: Data) {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ] as [String : Any]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    public class func delete() {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
    }

    private class func load() -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String : Any]

        var anyObj: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &anyObj)

        if status == noErr {
            return anyObj as! Data?
        } else {
            return nil
        }
    }
    
    public class func save(_ social: Social) {
        guard let data = try? JSONEncoder().encode(social) else {
            return
        }
        save(data: data)
    }
    
    public class func load() -> Social? {
        guard let data: Data = load(), let social = try? JSONDecoder().decode(Social.self, from: data) else {
            return nil
        }
        return social
    }

}
