//
//  FontListRemoteRepository.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import Foundation

protocol FontListRemoteRepositorySpec {
    func fetch(_ completion: @escaping (Result<[FontEntity], Error>) -> Void)
}

final class FontListRemoteRepository: FontListRemoteRepositorySpec {
    
    let service: NetworkServiceSpec
    
    init(service: NetworkServiceSpec = NetworkService.default) {
        self.service = service
    }

    func fetch(_ completion: @escaping (Result<[FontEntity], Error>) -> Void) {
        let request = FontListRequest()
        service.send(request) { result in
            switch result {
            case .success(let fontListDTO):
                do {
                    let result = try fontListDTO.fonts.map { try FontEntity(fontDTO: $0) }
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
