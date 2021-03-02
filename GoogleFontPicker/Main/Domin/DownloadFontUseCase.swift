//
//  DownloadFontUseCase.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/2.
//

import Foundation

protocol FontRepository {
    func download(url: URL, completion: @escaping (Data) -> Void)
}

final class DownloadFontUseCase {
    
    let repository: FontRepository
    
    init(repository: FontRepository) {
        self.repository = repository
    }
}

extension DownloadFontUseCase {
    
    func download(url: URL, completion: @escaping (Data) -> Void) {
        repository.download(url: url, completion: completion)
    }
}
