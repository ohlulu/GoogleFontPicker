//
//  FontRepository.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/2.
//

import Foundation

protocol FontRepositorySpec {
    func download(url: URL, completion: @escaping (Data) -> Void)
}

final class FontRepository {
    
    let service: NetworkServiceSpec
    
    init(service: NetworkServiceSpec = NetworkService.default) {
        self.service = service
    }
}

extension FontRepository: FontRepositorySpec {
    
    func download(url: URL, completion: @escaping (Data) -> Void) {
        
    }
}
