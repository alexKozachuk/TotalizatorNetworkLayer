//
//  TotalizatorEndPoint.swift
//  
//
//  Created by Sasha on 19/03/2021.
//

import Foundation

enum NetworkEnvironment {
    case production
}

public enum TotalizatorApi {
    case login(login: String, password: String)
    case registration(login: String, password: String, dateOfBirth: Date, username: String)
    case feed
    case wallet
    case walletHistory
    case makeTransaction(amount: Double, type: TransactionType)
    case bets
    case makeBet(amount: Double, choice: PossibleResult, eventID: String)
    case getEvent(id: String)
    case chat
    case sendMessage(text: String)
    case userInfo
}

extension TotalizatorApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://classic-totalizator-ajg2w.ondigitalocean.app/api"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .login:
            return "/Auth/login"
        case .registration:
            return "/Auth/register"
        case .feed:
            return "/Events/feed"
        case .wallet:
            return "/Wallet"
        case .walletHistory:
            return "/Wallet"
        case .makeTransaction:
            return "/Wallet/transaction"
        case .bets:
            return "/Bet/\(NetworkManager.APIKey)"
        case .makeBet:
            return "/Bet"
        case .getEvent(let id):
            return "/Events/preview/\(id)"
        case .chat:
            return "/Chat"
        case .sendMessage:
            return "/Chat"
        case .userInfo:
            return "/Account/\(NetworkManager.APIKey)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login, .registration, .makeTransaction, .makeBet, .sendMessage:
            return .post
        case .feed, .wallet, .walletHistory, .bets, .getEvent, .chat, .userInfo:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .login(let login, let password):
            return .requestParameters(bodyParameters: ["login": login,
                                                       "password": password],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
        case .registration(let login, let password, let dateOfBirth, let username):
            return .requestParameters(bodyParameters: ["email": login,
                                                       "password": password,
                                                       "dob": dateOfBirth.isoDateFormat,
                                                       "accountCreationTime": Date().isoDateFormat,
                                                       "username": username],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
        case .wallet:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: ["Authorization":"Bearer \(NetworkManager.APIKey)"])
        case .walletHistory:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: ["Authorization":"Bearer \(NetworkManager.APIKey)"])
        case .makeTransaction(let amount, let type):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: ["amount": amount,
                                                                "type":type.rawValue],
                                                additionHeaders: ["Authorization":"Bearer \(NetworkManager.APIKey)"])
        case .bets:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: ["Authorization":"Bearer \(NetworkManager.APIKey)"])
        case .makeBet(let amount, let choice, let eventID):
            return .requestParametersAndHeaders(bodyParameters: ["event_Id": eventID,
                                                                 "choice": choice.rawValue,
                                                                 "amount": amount],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: ["Authorization":"Bearer \(NetworkManager.APIKey)"])
        case .chat:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: ["Authorization":"Bearer \(NetworkManager.APIKey)"])
        case .sendMessage(let text):
            return .requestParametersAndHeaders(bodyParameters: ["text": text],
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: ["Authorization":"Bearer \(NetworkManager.APIKey)"])
        case .userInfo:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: ["Authorization":"Bearer \(NetworkManager.APIKey)"])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
