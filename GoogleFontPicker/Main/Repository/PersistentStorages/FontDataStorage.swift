//
//  FontDataStorage.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/2.
//

import Foundation

protocol FontDataStorage {
    typealias FontData = Data
    func list(completion: @escaping ((Result<[FontData], Error>) -> Void))
    func save(
        fontName: String,
        withFontData fontData: FontData,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )
}

final class FileManagerFontDataStorage {
    
    private let fileManager: FileManager
    private let directoryURL: URL?
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        self.directoryURL = fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("FontData")
    }
}

extension FileManagerFontDataStorage: FontDataStorage {
    
    func list(completion: @escaping ((Result<[FontData], Error>) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self,
                  let directoryURL = self.directoryURL else { return }
            do {
                let fileNames = try self.fileManager.contentsOfDirectory(atPath: directoryURL.path)
                let result: [FontData] = try fileNames.map { fileName in
                    let url = directoryURL.appendingPathComponent(fileName)
                    return try Data(contentsOf: url)
                }
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func save(
        fontName: String,
        withFontData fontData: FontData,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self,
                  let directoryURL = self.directoryURL else { return }
            do {
                try fontData.write(to: directoryURL.appendingPathComponent(fontName), options: .atomicWrite)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}