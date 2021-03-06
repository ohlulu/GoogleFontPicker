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
    var updateIndex: Observable<(Int, () -> Void)> { get }
    var textViewFontName: Observable<String?> { get }
}

typealias MainViewModelInterface =  MainViewModelInput & MainViewModelOutput

final class MainViewModel: MainViewModelInterface {
    
    // Output
    let error: Observable<String> = Observable("")
    let fontList: Observable<[FontTableViewCellViewObject]> = Observable([])
    let updateIndex: Observable<(Int, () -> Void)> = Observable((0 ,{}))
    let textViewFontName: Observable<String?> = Observable(nil)

    // Property
    private let fetchFontUseCase: FetchFontsUseCase
    private let registerFontUseCase: RegisterFontUseCase
    private let downloadUseCase: DownloadFontUseCase
    
    private var currentSelectedIndex: Int?
    
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
                    if let index = self.fontList.value.firstIndex(where: { $0.font.fontName != ".SFUI-Regular" }) {
                        self.update(isSelected: true, at: index)
                        let viewObject = self.fontList.value[index]
                        self.textViewFontName.value = viewObject.fontName
                    }
                }
            case .failure(let error):
                self.handle(error: error)
            }
        }
    }
    
    func didSelectedRow(at index: Int) {
        if !(fontList.value.indices ~= index) { return }
        let viewObject = fontList.value[index]
        
        if let currentSelectedIndex = currentSelectedIndex {
            self.update(isSelected: false, at: currentSelectedIndex) {
                self.update(isSelected: true, at: index) { [weak self] in
                    guard let self = self else { return }
                    switch viewObject.status {
                    case .notExist:
                        self.update(viewObjectAt: index, toStatus: .downloading) { [weak self] in
                            guard let self = self else { return }
                            self.downloadUseCase.downloadFont(name: viewObject.fontName, url: viewObject.fileURL) { [weak self] result in
                                guard let self = self else { return }
                                switch result {
                                case .success:
                                    self.registerFontUseCase.registerFont(fontName: viewObject.fontName) { result in
                                        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) { // for test
                                            switch result {
                                            case .success:
                                                self.update(viewObjectAt: index, toStatus: .exist)
                                                self.textViewFontName.value = viewObject.fontName
                                            case .failure(let error):
                                                self.update(viewObjectAt: index, toStatus: .notExist)
                                                self.handle(error: error)
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    self.handle(error: error)
                                }
                            }
                        }
                    case .exist:
                        self.textViewFontName.value = viewObject.fontName
                    case .downloading:
                        break
                    }
                }
            }
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
    
    func update(viewObjectAt index: Int, toStatus status: FontTableViewCellViewObject.Status, completion: @escaping (() -> Void) = {}) {
        let fontEntity = fontList.value[index]
        fontEntity.status = status
        fontEntity.reloadFont()
        updateIndex.value = (index, completion)
    }
    
    func update(isSelected: Bool, at index: Int, completion: @escaping (() -> Void) = {}) {
        fontList.value[index].isSelected = isSelected
        updateIndex.value = (index, completion)
        if isSelected {
            currentSelectedIndex = index
        }
    }
    
    private func handle(error: Error) {
        self.error.value = NSLocalizedString("something is wrong: \(error)", comment: "")
    }
}
