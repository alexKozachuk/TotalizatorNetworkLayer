//
//  TestEndPoint.swift
//  
//
//  Created by Sasha on 19/03/2021.
//

import Foundation

enum NetworkEnvironment {
    case production
}

public enum TotalizatorApi {
    case todo(id: Int)
    case posts
    case makePost(title: String, body: String, userId: Int)
}

extension TotalizatorApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://jsonplaceholder.typicode.com"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .todo(let id):
            return "/todos/\(id)"
        case .posts, .makePost:
            return "/posts"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .todo, .posts:
            return .get
        case .makePost:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .makePost(let title, let body, let id):
            return .requestParameters(bodyParameters: ["title": title,
                                                       "body": body,
                                                       "userId": "\(id)"],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
