//
//  FontListRemoteRepository.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import Foundation

protocol FontListRemoteRepositorySpec {
    func fetch(_ completion: @escaping (Result<FontListEntity, Error>) -> Void)
}

final class FontListRemoteRepository: FontListRemoteRepositorySpec {

    func fetch(_ completion: @escaping (Result<FontListEntity, Error>) -> Void) {
        
    }
}
