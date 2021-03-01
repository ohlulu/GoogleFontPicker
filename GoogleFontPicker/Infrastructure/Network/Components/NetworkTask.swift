//
//  NetworkTask.swift
//  ohlulu
//
//  Created by Ohlulu on 2021/2/4.
//  Copyright © 2021 ohlulu. All rights reserved.
//

import Foundation

/// Represents an HTTP task.
///
/// - Note: After iOS13, `HTTP body` should not have data, if `HTTP method` is "GET".
/// https://developer.apple.com/documentation/ios-ipados-release-notes/ios-13-release-notes#3319752.
public enum NetworkTask {
    
    /// A simple request, without any parameter.
    case simple
    
    /// A request URL set with `Encodable` type.
    case urlEncodeEncodable(Encodable)

    /// A request body set with `Encodable` type.
    case jsonEncodeEncodable(Encodable)
}
