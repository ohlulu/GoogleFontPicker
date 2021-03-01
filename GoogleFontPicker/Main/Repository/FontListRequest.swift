//
//  FontListRequest.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import Foundation

struct FontListParameter: Encodable {
    let key = "AIzaSyAu-HVTWv7uqHr2ieEhWXQ3fomyFX90ESY"
}

struct FontListRequest: NetworkRequest {

    typealias Entity = FontListDTO
    
    var baseURL: URL = URL(string: "https://www.googleapis.com/")!
    var path: String = "webfonts/v1/webfonts"
    var method: HTTPMethod = .get
    let parameter = FontListParameter()
    var task: NetworkTask { .urlEncodeEncodable(parameter) }
}

/// https://developers.google.com/fonts/docs/developer_api
struct FontListDTO: Decodable {
    
    let fonts: [Font]
    
    struct Font: Decodable {
        
        /// The name of the family
        let family: String
        
        /// The font family files (with all supported scripts) for each one of the available variants.
        let files: [String: String]
        
        /// The font variants. It also a key name of files.
        let variants: [String]
    }
}

// MARK: - FontListEntity CodingKeys

private extension FontListDTO {
    
    enum CodingKeys: String, CodingKey {
        case fonts = "items"
    }
}
