//
//  Feed.swift
//  
//
//  Created by Sasha on 22/03/2021.
//

import Foundation

// MARK: - Feed
public struct Feed: Codable {
    let events: [Event]
}

// MARK: - Event
public struct Event: Codable {
    let id: String
    let participant1, participant2: Participant
    let startTime, sportName: String
    let margin: Double
    let possibleResults: [PossibleResult]
    let isEnded: Bool
    let amountW1, amountW2, amountX: Int
}

// MARK: - Participant
public struct Participant: Codable {
    let id, name: String
    let photoLink: String
}

public enum PossibleResult: String, Codable {
    case w1 = "W1"
    case w2 = "W2"
    case x = "X"
}
