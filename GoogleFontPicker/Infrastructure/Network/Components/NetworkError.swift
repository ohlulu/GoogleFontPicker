//
//  NetworkError.swift
//  ohlulu
//
//  Created by Ohlulu on 2020/11/9.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

// MARK: - Network Error.

/// Error in the entire network request.
public enum NetworkError: Error {

    public enum ResponseErrorReason {

        /// Receive invalid HTTP status code and data.
        case invalidHTTPStatus(code: Int, data: Data)

        /// The receive data cannot decode to an instance of the target type.
        case decodeFailed(Error)

        /// The response of `HTTPURLResponse` is nil.
        case nonHTTPURLResponse

        /// The response of `HTTPBody` is nil.
        case nilData

        /// The error from `URLSession`.
        case URLSessionError(Error)
    }

    /// About parameter error.
    public enum BuildRequestFailedReason: Swift.Error {

        /// Only support `GET` & `POST` for sample.
        case methodNonsupport

        /// URL encode failed with an error from `URLEncoder`
        case urlEncodeFail(error: Error)

        /// JSON encode failed with an error form `JSONEncoder` or `HTTPBodyEncoder`.
        case jsonEncodeFail(error: Error)

        /// invalid url
        case invalidURL
    }

    /// Occurred on `Service` build `URLRequest`,
    case buildRequestFailed(reason: BuildRequestFailedReason)

    /// An error with receive response
    case responseFailed(reason: ResponseErrorReason)

    /// An error not be correct defined.
    case undefined(error: Error)
}

// MARK: - Network convert helper.

public extension Error {

    func asNetworkError() -> NetworkError {
        return (self as? NetworkError) ?? .undefined(error: self)
    }
}

// MARK: - Network equal helper.

public extension NetworkError {

    var isNilData: Bool {
        if case .responseFailed(.nilData) = self {
            return true
        }
        return false
    }

    var isNonHTTPURLResponse: Bool {
        if case .responseFailed(.nonHTTPURLResponse) = self {
            return true
        }
        return false
    }

    var isURLSessionError: Bool {
        if case .responseFailed(.URLSessionError) = self {
            return true
        }
        return false
    }

    var isBuildRequestMethodNonsupport: Bool {
        if case .buildRequestFailed(.methodNonsupport) = self {
            return true
        }
        return false
    }
}
