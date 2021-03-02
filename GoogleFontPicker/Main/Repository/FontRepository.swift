//
//  FontRepository.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/2.
//

import Foundation

protocol FontRepositorySpec {
    func download(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class FontRepository {
    
    let service: NetworkServiceSpec
    
    init(service: NetworkServiceSpec = NetworkService.default) {
        self.service = service
    }
}

extension FontRepository: FontRepositorySpec {
    
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
