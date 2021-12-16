//
//  DoctorModel.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 05/12/21.
//

//import Foundation
//
//struct Doctor: Codable {
//    let name, spesialis, desc, image: String
//    let id, timetable: String
//
//    enum CodingKeys: String, CodingKey {
//        case name, timetable
//        case id, spesialis, desc, image
//    }
//}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let doctor = try? newJSONDecoder().decode(Doctor.self, from: jsonData)

import Foundation

// MARK: - Doctor
struct Doctor: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let name, nip, spesialis, location: String
    let timetable, phone: String
    let img: String
    let desc, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, nip, spesialis, location, timetable, phone, img, desc
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
