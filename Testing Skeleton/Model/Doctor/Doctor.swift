//
//  DoctorModel.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 05/12/21.
//

import Foundation

struct Doctor: Codable {
    let name, placeOfBirth, dateOfBirth, gender: String
    let address, email, password: String
    let telp: Int
    let id: String

    enum CodingKeys: String, CodingKey {
        case name
        case placeOfBirth = "place_of_birth"
        case dateOfBirth = "date_of_birth"
        case gender, address, email, password, telp, id
    }
}
