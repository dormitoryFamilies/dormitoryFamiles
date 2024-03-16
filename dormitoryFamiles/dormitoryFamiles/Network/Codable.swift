//
//  Codable.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/08.
//

import Foundation

struct Article: Codable {
    let articleId: Int
    let nickName: String
    let profileUrl: String
    let boardType: String
    let title: String
    let content: String
    let commentCount: Int
    let wishCount: Int
    let isWished: Bool
    let status: String
    let createdAt: String
    let thumbnailUrl: String?
    let viewCount: Int
}


struct ArticleData: Codable {
    let articles: [Article]
}

struct ArticleResponse: Codable {
    let code: Int
    let data: ArticleData
}

struct Post: Codable {
    let dormitoryType: String
    let boardType: String
    let title: String
    let content: String
    let tags: String
    let imagesUrls: [String]
}

struct PostResponse: Decodable {
    let code: Int
    let data: ResponseData

    struct ResponseData: Decodable {
        let articleId: Int
    }
}

struct DetailResponse: Codable {
    let code: Int
    let data: ArticleDetail
}

struct ArticleDetail: Codable {
    let articleId: Int
    let memberId: Int
    let nickName: String
    let profileUrl: String
    let memberDormitory: String
    let articleDormitory: String
    let boardType: String
    let tags: String
    let title: String
    let content: String
    let wishCount: Int
    let isWished: Bool
    let status: String
    let createdAt: String
    let imagesUrls: [String]
}


struct ReplyResponse: Codable {
    let code: Int
    let data: DataClass
}

struct DataClass: Codable {
    let totalCount: Int
    let comments: [Comment]
}

struct Comment: Codable {
    let commentId: Int
    let memberId: Int
    let profileUrl: String
    let nickName: String
    let createdAt: String
    let content: String
    let isWriter: Bool
    let isDeleted: Bool
    let replyComments: [ReplyComment]?
}

struct ReplyComment: Codable {
    let replyCommentId: Int
    let memberId: Int
    let profileUrl: String
    let nickname: String
    let createdAt: String
    let content: String
    let isWriter: Bool
}

struct ReplyDelete: Codable {
    let code: Int
    let errorMessage: String
}
