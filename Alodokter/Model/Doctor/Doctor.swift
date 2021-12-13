//
//  DoctorModel.swift
//  Alodokter
//
//  Created by Prince Alvin Yusuf on 05/12/21.
//

import Foundation

struct Doctor: Codable {
    let name, spesialis, desc, image: String
    let id, timetable: String

    enum CodingKeys: String, CodingKey {
        case name, timetable
        case id, spesialis, desc, image
    }
}
