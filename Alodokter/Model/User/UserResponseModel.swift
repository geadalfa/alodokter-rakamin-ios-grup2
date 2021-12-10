//
//  UserResponseModel.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 09/12/21.
//

import Foundation

// MARK: - DoctorModel
struct UserResponseModel: Codable {
    let lastLogin: Int
    let address, userStatus, gender: String
    let created: Int
    let accountType, ownerID, socialAccount, birthDate: String
    let name, doctorModelClass, blUserLocale: String
    let updated: Int
    let email, objectID: String

    enum CodingKeys: String, CodingKey {
        case lastLogin, address, userStatus, gender, created, accountType
        case ownerID = "ownerId"
        case socialAccount, birthDate, name
        case doctorModelClass = "___class"
        case blUserLocale, updated, email
        case objectID = "objectId"
    }
}
