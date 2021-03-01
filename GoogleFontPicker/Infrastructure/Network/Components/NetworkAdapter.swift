//
//  NetworkAdapter.swift
//  ohlulu
//
//  Created by Ohlulu on 2020/11/5.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

/// Adapts a `URLRequest`
public protocol NetworkAdapter {

    /// Adapts an input `URLRequest` and return a modified object.
    ///
    /// - Parameter request: The request to be adapted.
    /// - Returns: The modified `URLRequest` object.
    /// - Throws: An error during the adapting process.
    func adapted(_ request: URLRequest) throws -> URLRequest
}

// MARK: - HeaderAdapter

/// Adapts header field to a request.
struct HeaderAdapter: NetworkAdapter {

    let data: [String: String]

    init(data: [String: String]) {
        self.data = data
    }

    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        data.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}

// MARK: - MethodAdapter

/// Adapts HTTP method to a request.
struct MethodAdapter: NetworkAdapter {

    let method: HTTPMethod

    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.httpMethod = method.rawValue

        switch method {
        case .get:
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        case .post:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}

// MARK: - TaskAdapter

struct AnyEncodableWrapper: Encodable {

    private let encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

/// Implementation `URLRequest` according to the `NetworkTask`.
struct TaskAdapter: NetworkAdapter {
    
    let task: NetworkTask
    
    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        switch task {
        case .simple:
            return request
        case let .urlEncodeEncodable(encodable):
            let encodableObject = AnyEncodableWrapper(encodable)
            return try Result<URLRequest, Error> { try URLEncoder().encode(encodableObject, with: request) }
                .mapError { NetworkError.buildRequestFailed(reason: .urlEncodeFail(error: $0)) }.get()

        case let .jsonEncodeEncodable(encodable):
            let encodableObject = AnyEncodableWrapper(encodable)
            request.httpBody = try Result<Data, Error> { try JSONEncoder().encode(encodableObject) }
                .mapError { NetworkError.buildRequestFailed(reason: .jsonEncodeFail(error: $0)) }.get()
            return request
        }
    }
}
