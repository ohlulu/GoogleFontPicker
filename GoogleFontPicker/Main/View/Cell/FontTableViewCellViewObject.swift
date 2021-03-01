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
    
    init(entity: FontEntity) {
        self.familyName = entity.family
        let font = UIFont(name: entity.info.fontName, size: 18) // size is not important
        if let font = font {
            self.font = font
            self.status = .exist
        } else {
            self.font = .systemFont(ofSize: 18)
            self.status = .notExist
        }
    }
}
