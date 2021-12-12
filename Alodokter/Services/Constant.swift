//
//  Constant.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import Foundation

let userDefault = UserDefaults.standard

let baseURL = "https://unitedpaper.backendless.app/api/users"
let registerURL = "\(baseURL)/register"
let loginURL = "\(baseURL)/login"
let logoutURL = "\(baseURL)/logout"


struct TokenKey {
    static let userLogin = "userLoginKey"
}


class UserDefaultService {
    static let instance = UserDefaultService()
    private let def = UserDefaults.standard
    fileprivate let isFirstLaunchedKey = "welcomeShown"
    
    var isFirstLaunched: Bool {
        get {
            return def.bool(forKey: isFirstLaunchedKey)
        }
        set {
            def.set(newValue, forKey: isFirstLaunchedKey)
        }
    }
}

