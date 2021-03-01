//
//  NetworkSession.swift
//  ohlulu
//
//  Created by Ohlulu on 2020/11/6.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

/// Provide request-able, response-able method
public protocol NetworkSession {

    func request(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkCancelable
}

/// A custom session to wrapper third-party framework
public final class DefaultNetworkSession: NetworkSession {

    private let urlSession = URLSession(
        configuration: URLSessionConfiguration.default,
        delegate: nil,
        delegateQueue: nil
    )
    
    public init() {}

    public func request(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkCancelable {
        let task = urlSession.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}
