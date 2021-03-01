//
//  NetworkCancelable.swift
//  ohlulu
//
//  Created by Ohlulu on 2020/11/9.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public protocol NetworkCancelable {
    func cancelRequest()
}

extension URLSessionDataTask : NetworkCancelable {
    public func cancelRequest() {
        cancel()
    }
}
