//
//  MainViewModel.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import Foundation

/// Input
protocol MainViewModelInput {
    func viewDidLoad()
    func didSelectedRow(at index: Int)
}

/// Output
protocol MainViewModelOutput {
    var error: Observable<String> { get }
    var fontList: Observable<[FontTableViewCellViewObject]> { get }
    var updateIndex: Observable<Int> { get }
}

typealias MainViewModelInterface =  MainViewModelInput & MainViewModelOutput

final class MainViewModel: MainViewModelInterface {
    
    // Output
    let error: Observable<String> = Observable("")
    let fontList: Observable<[FontTableViewCellViewObject]> = Observable([])
    let updateIndex: Observable<Int> = Observable(0)

    // Property
    private let fetchFontUseCase: FetchFontsUseCase
    private let registerFontUseCase: RegisterFontUseCase
    private let downloadUseCase: DownloadFontUseCase
    
    // Life cycle
    init(
        fetchFontUseCase: FetchFontsUseCase,
        registerFontUseCase: RegisterFontUseCase,
        downloadUseCase: DownloadFontUseCase
    ) {
        self.fetchFontUseCase = fetchFontUseCase
        self.registerFontUseCase = registerFontUseCase
        self.downloadUseCase = downloadUseCase
    }
}

// MARK: - MainViewModelInput

extension MainViewModel {
    
    func viewDidLoad() {
        fetchFontUseCase.fetchFonts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fontList):
                self.registerAllFont { [weak self] in
                    guard let self = self else { return }
                    self.fontList.value = fontList.map { FontTableViewCellViewObject(entity: $0) }
                }
            case .failure(let error):
                self.handle(error: error)
            }
        }
    }
    
    func didSelectedRow(at index: Int) {
        if !(fontList.value.indices ~= index) { return }
        let viewObject = fontList.value[index]
        switch viewObject.status {
        case .notExist:
            downloadUseCase.downloadFont(name: viewObject.fontName, url: viewObject.fileURL) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.registerFontUseCase.registerFont(fontName: viewObject.fontName) { result in
                        switch result {
                        case .success:
                            // TODO: Update VO
                            break
                        case .failure(let error):
                            self.handle(error: error)
                        }
                    }
                case .failure(let error):
                    self.handle(error: error)
                }
            }
        case .downloading, .exist:
            break
        }
    }
}

// MARK: - Output

extension MainViewModel {
    
}

// MARK: - Helper

private extension MainViewModel {
    
    func registerAllFont(completion: @escaping () -> Void) {
        registerFontUseCase.registerAll { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: break
            case .failure(let error):
                self.handle(error: error)
            }
            completion()
        }
    }
    
    private func handle(error: Error) {
        self.error.value = NSLocalizedString("something is wrong: \(error)", comment: "")
    }
}
