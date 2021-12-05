//
//  Constant.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import Foundation

let baseURL = "https://unitedpaper.backendless.app/api/users"
let registerURL = "\(baseURL)/register"
let loginURL = "\(baseURL)/login"
let logoutURL = "\(baseURL)/logout"
let doctorURL = "https://newsapi.org/v2/top-headlines?country=id&apiKey=c910bfd484464746b4c911b0615c1028"

struct TokenKey {
    static let userLogin = "userLoginKey"
}
