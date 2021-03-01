//
//  XCTestCase+Extension.swift
//  GoogleFontPickerTests
//
//  Created by Ohlulu on 2021/3/1.
//

import Foundation
import XCTest

extension XCTestCase {
    
    func read(fileName: String, ofType fileType: String) throws -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: fileType) else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
}
