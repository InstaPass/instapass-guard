//
//  UserPrefInitializer.swift
//  InstaPass
//
//  Created by 法好 on 2020/5/10.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import Foundation

class UserPrefInitializer {
    
    static let userDefault = UserDefaults.standard
    
    static var jwtToken: String {
        get {
            return userDefault.string(forKey: UserPrefKeys.jwtToken.rawValue) ?? ""
        }
        set {
            userDefault.set(newValue, forKey: UserPrefKeys.jwtToken.rawValue)
        }
    }
    
    static var userName: String {
        get {
            return userDefault.string(forKey: UserPrefKeys.userName.rawValue) ?? ""
        }
        set {
            userDefault.set(newValue, forKey: UserPrefKeys.userName.rawValue)
        }
    }
    
    static var passWord: String {
        get {
            return userDefault.string(forKey: UserPrefKeys.passWord.rawValue) ?? ""
        }
        set {
            userDefault.set(newValue, forKey: UserPrefKeys.passWord.rawValue)
        }
    }
}

enum UserPrefKeys: String {
    case jwtToken = "userPrefKeys.JwtToken"
    case userName = "userPrefKeys.userName"
    case passWord = "userPrefKeys.passWord"
}
