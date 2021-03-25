//
//  File.swift
//  
//
//  Created by Sasha on 25/03/2021.
//

import Foundation

// MARK: - Messages
struct Messages: Codable {
    let messages: [Message]
}

// MARK: - Message
struct Message: Codable {
    let id, text, username, accountID: String
    let avatarLink, time: String

    enum CodingKeys: String, CodingKey {
        case id, text, username
        case accountID = "account_Id"
        case avatarLink, time
    }
}
