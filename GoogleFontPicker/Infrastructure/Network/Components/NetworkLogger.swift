//
//  NetworkLogger.swift
//  ohlulu
//
//  Created by Ohlulu on 2020/11/9.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public protocol NetworkLogger {

    var needLog: Bool { get }
    func log(_ message: String)
}

// TODO: 之後看要用套件來接，或是自己做一個，這邊先單純 print
public final class DefaultHTTPLogger: NetworkLogger {

    #if DEBUG
        public let needLog: Bool = true
    #else
        public let needLog: Bool = false
    #endif

    public func log(_ message: String) {
        if !needLog { return }
        print(message)
    }
}
