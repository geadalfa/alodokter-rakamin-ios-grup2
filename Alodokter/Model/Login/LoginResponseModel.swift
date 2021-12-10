//
//  ResponseModel.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 03/12/21.
//

import Foundation

struct LoginResponseModel: Codable {
    let lastLogin: Int
    let address, userStatus, gender: String
    let created: Int
    let accountType, ownerID, socialAccount, birthDate: String
    let name, responseModelClass, blUserLocale, userToken: String
    let email, objectID: String

    enum CodingKeys: String, CodingKey {
        case lastLogin, address, userStatus, gender, created, accountType
        case ownerID = "ownerId"
        case socialAccount, birthDate, name
        case responseModelClass = "___class"
        case blUserLocale
        case userToken = "user-token"
        case email
        case objectID = "objectId"
    }
}
