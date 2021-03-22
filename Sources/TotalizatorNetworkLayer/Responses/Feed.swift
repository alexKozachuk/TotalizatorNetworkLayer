//
//  Feed.swift
//  
//
//  Created by Sasha on 22/03/2021.
//

import Foundation

// MARK: - Feed
public struct Feed: Codable {
    public let events: [Event]
}

// MARK: - Event
public struct Event: Codable {
    public let id, participantId1, participantId2, startTime: String
    public let sportID: Int
    public let margin: Double
    public let possibleResults: [PossibleResult]
    public let isEnded: Bool
    public let eventResult: String?

    enum CodingKeys: String, CodingKey {
        case id
        case participantId1 = "participant_Id1"
        case participantId2 = "participant_Id2"
        case startTime
        case sportID = "sport_Id"
        case margin, possibleResults, isEnded, eventResult
    }
}

public enum PossibleResult: String, Codable {
    case w1 = "W1"
    case w2 = "W2"
    case x = "X"
}
