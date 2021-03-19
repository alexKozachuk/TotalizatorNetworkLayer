//
//  File.swift
//  
//
//  Created by Sasha on 19/03/2021.
//

import Foundation

// MARK: - Todo
public struct Todo: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
