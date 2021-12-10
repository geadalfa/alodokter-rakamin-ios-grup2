//
//  RegisterModel.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import Foundation

struct RegisterModel: Encodable {
    let name: String
    let email: String
    let password: String
    let address: String
    let gender: String
    let birthDate: String
    
}
