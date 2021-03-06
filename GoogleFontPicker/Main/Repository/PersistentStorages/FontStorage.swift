//
//  FontStorage.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/2.
//

import Foundation

protocol FontStorage {
    typealias FontData = Data
    func listAllFontData(completion: @escaping ((Result<[FontData], Error>) -> Void))
    func readFontData(fontName: String, completion: @escaping ((Result<FontData, Error>) -> Void))
    func save(
        fontName: String,
        withFontData fontData: FontData,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )
}

final class FileManagerFontDataStorage {
    
    private enum StorageError: Error {
        case fontNotExist
    }
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

extension FileManagerFontDataStorage: FontStorage {
    
    func listAllFontData(completion: @escaping ((Result<[FontData], Error>) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self,
                  let directoryURL = self.directoryURL else { return }
            do {
                let fileURLs = try self.fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                let result: [FontData] = try fileURLs.map { fileURL in
                    return try Data(contentsOf: fileURL)
                }
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func readFontData(fontName: String, completion: @escaping ((Result<FontData, Error>) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self,
                  let directoryURL = self.directoryURL else { return }
            
            let tragetFileURL = directoryURL.appendingPathComponent(fontName)
            do {
                if self.fileManager.fileExists(atPath: tragetFileURL.path) {
                    let data = try Data(contentsOf: tragetFileURL)
                    completion(.success(data))
                } else {
                    completion(.failure(StorageError.fontNotExist))
                }
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
                if !self.fileManager.fileExists(atPath: directoryURL.path) {
                    try self.fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                }
                try fontData.write(to: directoryURL.appendingPathComponent(fontName), options: .atomicWrite)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
