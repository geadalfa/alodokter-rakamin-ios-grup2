//
//  Article.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 02/12/21.
//

import Foundation

struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct FetchArticle: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]?
}

struct Source: Codable {
    let id: String?
    let name: String?
}

