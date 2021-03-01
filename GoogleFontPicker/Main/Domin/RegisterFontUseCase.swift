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
    
    let repository: FontDataRepository
    
    init(repository: FontDataRepository) {
        self.repository = repository
    }
    
    func register(completion: @escaping ((Result<Void, Error>) -> Void)) {
        
        repository.list { result in
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
}

// MARK: - Helper

private extension RegisterFontUseCase {
    
    func registerFont(withFontData data: Data) throws {
        let dataProvider = CGDataProvider(data: data as NSData)
        let cgFont = CGFont(dataProvider!)!

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
            guard let error = error?.takeRetainedValue() else {
                return
            }
            throw error
        }
    }
}
