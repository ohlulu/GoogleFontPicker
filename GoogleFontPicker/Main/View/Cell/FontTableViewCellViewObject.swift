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
    
    let font: UIFont = .systemFont(ofSize: 100)
    let familyName: String = "123"
    let status: Status = .downloading
    var isSelected: Bool = false
    
    // TODO: entity -> view object
}
