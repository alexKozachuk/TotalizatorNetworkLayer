//
//  Post.swift
//  
//
//  Created by Sasha on 19/03/2021.
//

import Foundation

// MARK: - Post
public struct Post: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
