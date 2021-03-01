//
//  NetworkPlugin.swift
//  ohlulu
//
//  Created by Ohlulu on 2020/11/5.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

/// Plugin receives callbacks wherever a request is sent or received.
public protocol NetworkPlugin: AnyObject {
    func willSend<R: NetworkRequest>(_ request: R)
    func didReceive(_ response: NetworkResponse)
}

public extension NetworkPlugin {

    /// Called before sending.
    func willSend<R: NetworkRequest>(_ request: R) {}

    /// Called after response has been received.
    func didReceive(_ response: NetworkResponse) {}
}

// Log a HTTP request, response...etc information
class LogPlugin: NetworkPlugin {

    var startTime: Date?
    var endTime: Date?

    private let logger: NetworkLogger

    init(logger: NetworkLogger) {
        self.logger = logger
    }

    fileprivate static let formatter = DateFormatter()

    func willSend<R>(_ request: R) where R: NetworkRequest {
        
        if !logger.needLog { return }
        
        startTime = Date()
    }

    func didReceive(_ response: NetworkResponse) {
        
        if !logger.needLog { return }
        
        endTime = Date()

        let costTime: TimeInterval
        if let startTime = startTime, let endTime = endTime {
            costTime = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
        } else {
            costTime = 0
        }

        let method = format(response.request?.httpMethod)
        let path = format(response.request?.url?.path)
        let url = format(response.request?.url?.absoluteString)
        let header = format(response.request?.allHTTPHeaderFields)
        let requestBody = jsonString(data: response.request?.httpBody)
        let responseBody = jsonString(data: response.data)
        let requestTime = formatDate(startTime)
        
        let message = """
        >>> [ \(method) ] [ path: \(path) ]
        URL -> \(url)
        request time -> \(requestTime)
        cost time -> \(String(format: "%.3f", costTime)) s
        headers -> \(header)
        Request Body -> \(requestBody)
        Response Body -> \(responseBody)
        """

        logger.log(message)
    }

    private func format(_ context: Any?) -> String {
        if let context = context {
            return "\(context)"
        } else {
            return "nil"
        }
    }

    private func jsonString(data: Data?) -> String {
        guard let data = data,
              let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
              let json = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted),
              let string = String(data: json, encoding: .utf8) else {
            return "nil"
        }
        return string.replacingOccurrences(of: "\\", with: "")
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else {
            return "nil"
        }
        let formatter = LogPlugin.formatter
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }
}
