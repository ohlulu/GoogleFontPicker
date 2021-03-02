//
//  FontRepository.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/2.
//

import Foundation

protocol FontRepositorySpec {
    typealias FontData = Data
    func listAllFontData(completion: @escaping ((Result<[FontData], Error>) -> Void))
    func readFontData(fontName: String, completion: @escaping ((Result<FontData, Error>) -> Void))
    func download(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class FontRepository {
    
    private let service: NetworkServiceSpec
    private let storage: FontStorage
    
    init(
        service: NetworkServiceSpec,
        storage: FontStorage
    ) {
        self.service = service
        self.storage = storage
    }
}

extension FontRepository: FontRepositorySpec {
    
    func listAllFontData(completion: @escaping ((Result<[FontData], Error>) -> Void)) {
        storage.listAllFontData(completion: completion)
    }
    
    func readFontData(fontName: String, completion: @escaping ((Result<FontData, Error>) -> Void)) {
        storage.readFontData(fontName: fontName, completion: completion)
    }
    
    func download(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = DownloadFontRequest(url: url)
        service.send(request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct DownloadFontRequest: NetworkRequest {

    typealias Entity = Data

    var baseURL: URL
    let path: String = ""
    let method: HTTPMethod = .get
    let task: NetworkTask = .simple
    
    var decisions: [NetworkDecision] {
        return [
            StatusCodeDecision(valid: 200 ..< 399),
            RetryDecision(retryCount: 2),
            DataTypeTerminatorDecision()
        ]
    }
    
    init(url: URL) {
        self.baseURL = url
    }
}
