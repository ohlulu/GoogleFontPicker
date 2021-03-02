//
//  DownloadFontUseCase.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/2.
//

import Foundation

final class DownloadFontUseCase {
    
    let repository: FontRepositorySpec
    
    init(repository: FontRepositorySpec) {
        self.repository = repository
    }
}

extension DownloadFontUseCase {
    
    func download(url: URL, completion: @escaping (Data) -> Void) {
        repository.download(url: url, completion: completion)
    }
}
