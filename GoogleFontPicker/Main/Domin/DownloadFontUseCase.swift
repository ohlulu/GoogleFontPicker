//
//  DownloadFontUseCase.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/2.
//

import Foundation

final class DownloadFontUseCase {
    
    let repository: FontRepositorySpec
    let storage: FontDataStorage
    
    init(
        repository: FontRepositorySpec,
        storage: FontDataStorage
    ) {
        self.repository = repository
        self.storage = storage
    }
}

extension DownloadFontUseCase {
    
    func downloadFont(name: String, url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.download(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.storage.save(fontName: name, withFontData: data) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
