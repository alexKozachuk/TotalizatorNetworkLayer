//
//  WalletHistory.swift
//  
//
//  Created by Sasha on 22/03/2021.
//

import Foundation

// MARK: - WalletHistoryElement
public struct WalletHistoryElement: Codable, Equatable {
    public let amount: Double
    public let type, dateTime: String
}

public typealias WalletHistory = [WalletHistoryElement]
