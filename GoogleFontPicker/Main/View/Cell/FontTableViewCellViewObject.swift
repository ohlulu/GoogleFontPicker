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
    
    var font: UIFont
    let familyName: String
    var status: Status
    var isSelected: Bool = false
    
    let fontName: String
    let fileURL: URL
    
    init(entity: FontEntity) {
        self.familyName = entity.family
        self.fontName = entity.info.fontName
        
        if let font = UIFont(name: fontName, size: 18) {
            self.font = font
            self.status = .exist
        } else {
            self.font = .systemFont(ofSize: 18)
            self.status = .notExist
        }
        
        self.fileURL = entity.info.fileURL
    }
    
    func reloadFont() {
        if let font = UIFont(name: fontName, size: 18) {
            self.font = font
        } else {
            font = .systemFont(ofSize: 18)
        }
    }
}
