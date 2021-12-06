//
//  DoctorModel.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 05/12/21.
//

import Foundation

// MARK: - DoctorModelAPI
struct Doctor: Codable {
    let status: String
    let totalResults: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let title: String
    let link: String
    let keywords, creator: [String]?
    let pubDate: String
    let fullDescription: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case title, link, keywords, creator
        case pubDate
        case fullDescription = "full_description"
        case imageURL = "image_url"
    }
}
