//
//  FontEntity.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/2/27.
//

import Foundation

struct FontEntity {
    
    enum Error: Swift.Error {
        /// Missing file url string.
        case missingFileURL
        /// Invalid file url.
        case invalidFileURLString
        /// Variants is empty.
        case variantsEmpty
    }
    
    /// The name of the family
    let family: String
    
    // The font info, contains font name, file url.
    let info: Info
    struct Info {
        let fontName: String
        let fileURL: URL
    }
    
    init(fontDTO: FontListDTO.Font) throws {
        self.family = fontDTO.family
        
        // sort(?)
        guard let variant = fontDTO.variants.first else {
            throw Error.variantsEmpty
        }
        
        guard let fileURLString = fontDTO.files[variant] else {
            throw Error.missingFileURL
        }
        
        guard let url = URL(string: fileURLString) else {
            throw Error.invalidFileURLString
        }
        
        self.info = Info(fontName: "\(fontDTO.family)-\(variant)", fileURL: url)
    }
}
