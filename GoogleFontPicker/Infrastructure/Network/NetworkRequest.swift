//
//  NetworkRequest.swift
//  ohlulu
//
//  Created by Ohlulu on 2020/11/6.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

/// ohlulu API request components
public protocol NetworkRequest {

    associatedtype Entity: Decodable

    var baseURL: URL { get }

    var path: String { get }

    var method: HTTPMethod { get }

    var headers: [String: String] { get }

    var task: NetworkTask { get }

    var adapters: [NetworkAdapter] { get }

    var decisions: [NetworkDecision] { get }

    var plugins: [NetworkPlugin] { get }
}

// Provided NetworkRequest default value
public extension NetworkRequest {

    var adapters: [NetworkAdapter] {
        return [
            HeaderAdapter(data: headers),
            MethodAdapter(method: method),
            TaskAdapter(task: task)
        ]
    }

    var decisions: [NetworkDecision] {
        return [
            StatusCodeDecision(valid: 200 ..< 399),
            RetryDecision(retryCount: 2),
            DecodeDecision()
        ]
    }

    var plugins: [NetworkPlugin] {
        #if DEBUG
            return [
                LogPlugin(logger: DefaultHTTPLogger())
            ]
        #else
            return []
        #endif
    }

    var headers: [String: String] {
        return [:]
    }
}
