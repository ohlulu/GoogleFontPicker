//
//  FontDataRepository.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import Foundation

protocol FontDataRepositorySpec {
    typealias FontData = Data
    func list(completion: @escaping ((Result<[FontData], Error>) -> Void))
}

final class FontDataRepository {
    
    private let storage: FontDataStorage
    
    init(storage: FontDataStorage) {
        self.storage = storage
    }
}

extension FontDataRepository: FontDataRepositorySpec {
    
    func list(completion: @escaping ((Result<[FontData], Error>) -> Void)) {
        storage.list(completion: completion)
    }
}
