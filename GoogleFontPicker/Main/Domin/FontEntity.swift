//
//  FontEntity.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/2/27.
//

import Foundation

/// https://developers.google.com/fonts/docs/developer_api
struct FontListEntity: Decodable {
    
    let fonts: [Font]
    
    struct Font: Decodable {
        
        /// The name of the family
        let family: String
        
        // The font family files (with all supported scripts) for each one of the available variants.
        let files: Files
        
        struct Files: Decodable {
            let regular100: String?
            let regular200: String?
            let regular300: String?
            let regular400: String?
            let regular500: String?
            let regular600: String?
            let regular700: String?
            let regular800: String?
            let regular900: String?
            let italic100: String?
            let italic200: String?
            let italic300: String?
            let italic400: String?
            let italic500: String?
            let italic600: String?
            let italic700: String?
            let italic800: String?
            let italic900: String?
        }
    }
}

// MARK: - FontListEntity CodingKeys

private extension FontListEntity {
    
    enum CodingKeys: String, CodingKey {
        case fonts = "items"
    }
}

// MARK: - Items.Files CodingKeys

private extension FontListEntity.Font.Files {
    
    enum CodingKeys: String, CodingKey {
        case regular100 = "100"
        case regular200 = "200"
        case regular300 = "300"
        case regular400 = "regular"
        case regular500 = "500"
        case regular600 = "600"
        case regular700 = "700"
        case regular800 = "800"
        case regular900 = "900"
        case italic100 = "100italic"
        case italic200 = "200italic"
        case italic300 = "300italic"
        case italic400 = "italic"
        case italic500 = "500italic"
        case italic600 = "600italic"
        case italic700 = "700italic"
        case italic800 = "800italic"
        case italic900 = "900italic"
    }
}
