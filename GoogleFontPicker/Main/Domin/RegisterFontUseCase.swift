//
//  RegisterFontUseCase.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import CoreGraphics
import CoreText
import Foundation

class RegisterFontUseCase {
    
    let repository: FontRepositorySpec
    
    init(repository: FontRepositorySpec) {
        self.repository = repository
    }
    
    func registerAll(completion: @escaping ((Result<Void, Error>) -> Void)) {
        
        repository.listAllFontData { result in
            switch result {
            case .success(let fontDatas):
                do {
                    // Note: `foeEach(_:)` will break if `registerFont(_:)` catch error.
                    try fontDatas.forEach { try self.registerFont(withFontData: $0) }
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registerFont(fontName: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        repository.readFontData(fontName: fontName) { result in
            switch result {
            case .success(let data):
                do {
                    try self.registerFont(withFontData: data)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Helper

private extension RegisterFontUseCase {
    
    func registerFont(withFontData data: Data) throws {
        let dataProvider = CGDataProvider(data: data as NSData)
        let cgFont = CGFont(dataProvider!)!

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
            // 這邊怪怪的，要再研究一下
            guard let error = error?.takeRetainedValue() else {
                return
            }
            throw error
        }
    }
}
