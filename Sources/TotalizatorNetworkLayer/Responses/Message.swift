//
//  File.swift
//  
//
//  Created by Sasha on 25/03/2021.
//

import Foundation

// MARK: - Messages
public struct Messages: Codable, Equatable {
    public let messages: [Message]
}

// MARK: - Message
public struct Message: Codable, Equatable {
    public let id, text, username, accountID: String
    public let avatarLink: String?
    public let time: String

    enum CodingKeys: String, CodingKey {
        case id, text, username
        case accountID = "account_Id"
        case avatarLink, time
    }
}
