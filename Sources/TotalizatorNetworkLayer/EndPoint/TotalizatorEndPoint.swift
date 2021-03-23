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
    case registration(login: String, password: String, dateOfBirth: Date)
    case feed
    case wallet
    case walletHistory
    case makeTransaction(amount: Double, type: TransactionType)
    case bets
    case makeBet(amount: Double, choice: PossibleResult, eventID: String)
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
            return "/v1/Auth/Login"
        case .registration:
            return "/v1/Auth/register"
        case .feed:
            return "/Events/feed"
        case .wallet:
            return "/v1/wallet"
        case .walletHistory:
            return "/v1/wallet/transactionHistory"
        case .makeTransaction:
            return "/v1/wallet/transaction"
        case .bets:
            return "/v1/bet/account"
        case .makeBet:
            return "/v1/bet"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login, .registration, .makeTransaction, .makeBet:
            return .post
        case .feed, .wallet, .walletHistory, .bets:
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
        case .registration(let login, let password, let dateOfBirth):
            return .requestParameters(bodyParameters: ["email": login,
                                                       "password": password,
                                                       "dob": dateOfBirth.isoDateFormat,
                                                       "accountCreationTime": Date().isoDateFormat],
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
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
