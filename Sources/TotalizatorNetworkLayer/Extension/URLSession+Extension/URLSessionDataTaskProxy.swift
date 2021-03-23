//
//  URLSessionDataTaskProxy.swift
//  
//
//  Created by Sasha on 23/03/2021.
//

import Foundation

public protocol URLSessionDataTaskProxy {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProxy {}
