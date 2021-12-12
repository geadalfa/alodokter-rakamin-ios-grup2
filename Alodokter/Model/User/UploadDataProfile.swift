//
//  UserProfiles.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 12/12/21.
//

import Foundation

// Create model
struct UploadDataProfile: Codable {
    let name: String
    let address: String
    let gender: String
    let birthDate: String
}
