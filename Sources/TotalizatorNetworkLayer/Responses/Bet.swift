//
//  Bet.swift
//  
//
//  Created by Sasha on 23/03/2021.
//

import Foundation

// MARK: - Bets
public struct Bets: Codable, Equatable {
    public let betsPreviewForUsers: [BetsPreviewForUser]
}

// MARK: - BetsPreviewForUser
public struct BetsPreviewForUser: Codable, Equatable {
    public let betID, teamConfrontation: String
    public let choice: PossibleResult
    public let eventStartime, betTime: String
    public let amount: Int
    public let status: String?

    enum CodingKeys: String, CodingKey {
        case betID = "bet_Id"
        case teamConfrontation, choice, eventStartime, betTime, amount, status
    }
}
