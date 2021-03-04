//
//  FontEntity.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/2/27.
//

import Foundation

struct FontEntity {
    
    enum Error: Swift.Error {
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
        let defaultVariant = "regular"
        let noblankFamily = fontDTO.family.replacingOccurrences(of: " ", with: "")
        
        if let fileURLString = fontDTO.files[defaultVariant], // regular priority
           let url = URL(string: fileURLString) {
            self.info = Info(fontName: "\(noblankFamily)-\(defaultVariant)", fileURL: url)
        } else if let variant = fontDTO.variants.first, // or variants list first
                  let fileURLString = fontDTO.files[variant],
                  let url = URL(string: fileURLString) {
            self.info = Info(fontName: "\(noblankFamily)-\(variant)", fileURL: url)
        } else {
            throw Error.variantsEmpty
        }
    }
}
