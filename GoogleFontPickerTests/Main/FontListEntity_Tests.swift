//
//  FontListEntity_Tests.swift
//  GoogleFontPickerTests
//
//  Created by Ohlulu on 2021/3/1.
//

@testable import GoogleFontPicker
import XCTest

class FontListEntity_Tests: XCTestCase {

    func test_FontListEntity_shouldDecodeSuccess() throws {
        let jsonData = try XCTUnwrap(read(fileName: "FontListEntity", ofType: "json"))
        
        // should decode success
        _ = try JSONDecoder().decode(FontListEntity.self, from: jsonData)
    }
}
