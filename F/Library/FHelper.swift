//
//  FHelper.swift
//  F
//
//  Created by huchunbo on 15/11/7.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FHelper {
    
    // MARK:
    // MARK: - token
    
    static var token: String {
        return FTool.keychain.token()
    }
    
    static var tokenID: String {
        return FTool.keychain.tokenID()
    }
    
    static func setToken (id id: String, token: String) {
        FTool.keychain.defaultKeychain()["token"] = token
        FTool.keychain.defaultKeychain()["tokenID"] = id
    }
    
    static func clearToken () {
        FTool.keychain.defaultKeychain()["token"] = nil
        FTool.keychain.defaultKeychain()["tokenID"] = nil
    }
    
    // MARK:
    // MARK: - user information
    static var current_user: User {
        set (newValue) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(newValue.name, forKey: "name")
        userDefaults.setObject(newValue.email, forKey: "email")
        userDefaults.setInteger(newValue.id, forKey: "id")
        userDefaults.synchronize()
        }
        
        get {
            let valid: Bool = true
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let invalidUser = User(id: 0, name: String(), email: String(), valid: false)
            guard let name = userDefaults.stringForKey("name") else {return invalidUser}
            guard let email = userDefaults.stringForKey("email") else {return invalidUser}
            let id = userDefaults.integerForKey("id")
            
            return User(id: id, name: name, email: email, valid: valid)
        }
    }
    
    // MARK:
    // MARK: - user functions
    
    static var logged_in: Bool {
        if
        let token = try? FTool.keychain.defaultKeychain().getString("token"),
        let tokenID = try? FTool.keychain.defaultKeychain().getString("tokenID")
        {
            if token != nil && tokenID != nil {return true}
        }
        return false
    }
    
    static func current_user (user_id: Int) -> Bool {
        return current_user.id == user_id && current_user.valid && logged_in
    }
}
