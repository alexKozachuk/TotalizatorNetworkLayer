//
//  Feed.swift
//  
//
//  Created by Sasha on 22/03/2021.
//

import Foundation

// MARK: - Feed
public struct Feed: Codable, Equatable {
    public let events: [Event]
}

// MARK: - Event
public struct Event: Codable, Equatable {
    public let id: String
    public let participant1, participant2: Participant
    public let startTime, sportName: String
    public let margin: Double
    public let possibleResults: [PossibleResult]
    public let isEnded: Bool
    public let amountW1, amountW2, amountX: Int
}

// MARK: - Participant
public struct Participant: Codable, Equatable {
    public let id, name: String
    public let photoLink: String?
    public let parameters: [ParticipantParameters]
}

public enum PossibleResult: String, Codable, Equatable {
    case w1 = "W1"
    case w2 = "W2"
    case x = "X"
}

public struct ParticipantParameters: Codable, Equatable {
    public var type: String
    public var value: String
}
