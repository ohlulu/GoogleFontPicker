//
//  FontTableViewCellViewObject.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import UIKit

final class FontTableViewCellViewObject {
    
    enum Status {
        case notExist
        case downloading
        case exist
    }
    
    let font: UIFont
    let familyName: String
    let status: Status
    var isSelected: Bool = false
    
    let fontName: String
    let fileURL: URL
    
    init(entity: FontEntity) {
        self.familyName = entity.family
        self.fontName = entity.info.fontName
        
        // size is not important
        if let font = UIFont(name: fontName, size: 18) {
            self.font = font
            self.status = .exist
        } else {
            self.font = .systemFont(ofSize: 18)
            self.status = .notExist
        }
        
        self.fileURL = entity.info.fileURL
    }
}
