//
//  NetworkErrorDTO.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/6.
//

import Foundation

public struct NetworkErrorDTO: Decodable {
    struct Error: Decodable {
        let code: Int
        let message: String
    }
    let error: Error
}

extension NetworkErrorDTO: CustomStringConvertible {
    public var description: String {
        "error code: \(error.code), message: \(error.message)"
    }
}
