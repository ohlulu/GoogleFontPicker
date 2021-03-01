//
//  FetchFontsUseCase.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/2/27.
//

import Foundation

final class FetchFontsUseCase {
    
    private let repository: FontListRemoteRepositorySpec
    
    init(repository: FontListRemoteRepositorySpec) {
        self.repository = repository
    }
    
    func fetchFonts(_ completion: @escaping (Result<FontListEntity, Error>) -> Void) {
        repository.fetch(completion)
    }
}
