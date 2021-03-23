//
//  Bet.swift
//  
//
//  Created by Sasha on 23/03/2021.
//

import Foundation

// MARK: - Bet
public struct Bet: Codable {
    public let accountID, eventID: String
    public let choice: PossibleResult
    public let amount: Int

    enum CodingKeys: String, CodingKey {
        case accountID = "account_Id"
        case eventID = "event_Id"
        case choice, amount
    }
}

public typealias Bets = [Bet]
