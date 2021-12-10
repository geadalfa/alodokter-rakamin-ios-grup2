//
//  Token.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 05/12/21.
//

import UIKit

class Token {
    static let tokenInstance = Token()
    let userDefault = UserDefaults.standard
    
    func saveToken(token: String) {
        userDefault.set(token, forKey: TokenKey.userLogin)
    }
    
    func getToken() -> String {
        if let token = userDefault.object(forKey: TokenKey.userLogin) as? String {
            print("User Token: \(token)")
            return token
        } else {
            return ""
        }
        
    }
    
    func checkForLogin() -> Bool {
        if getToken() == "" {
            return false
        } else {
            return true
        }
    }
    
    func removeToken() {
        userDefault.removeObject(forKey: TokenKey.userLogin)
    }
}
