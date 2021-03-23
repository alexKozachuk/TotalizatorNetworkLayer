//
//  Bet.swift
//  
//
//  Created by Sasha on 23/03/2021.
//

import Foundation

// MARK: - Bet
public struct Bet: Codable {
    let accountID, eventID: String
    let choice: PossibleResult
    let amount: Int

    enum CodingKeys: String, CodingKey {
        case accountID = "account_Id"
        case eventID = "event_Id"
        case choice, amount
    }
}

public typealias Bets = [Bet]
