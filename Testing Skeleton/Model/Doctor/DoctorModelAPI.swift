//
//  DoctorModel.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 05/12/21.
//

import Foundation

// MARK: - DoctorModel
struct DoctorModelAPI: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let author: String?
    let title, articleDescription: String
    let url: String
    let urlToImage: String
    let content: String?

    enum CodingKeys: String, CodingKey {
        case author, title
        case articleDescription = "description"
        case url, urlToImage, content
    }
}
