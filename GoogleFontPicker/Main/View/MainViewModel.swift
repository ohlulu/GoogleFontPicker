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
    var error: Bindable<String> { get }
    var fontList: Bindable<[FontTableViewCellViewObject]> { get }
    var updateIndex: Bindable<(Int, () -> Void)> { get }
    var textViewFontName: Bindable<String?> { get }
}

typealias MainViewModelInterface =  MainViewModelInput & MainViewModelOutput

final class MainViewModel: MainViewModelInterface {
    
    // Output
    let error: Bindable<String> = Bindable("")
    let fontList: Bindable<[FontTableViewCellViewObject]> = Bindable([])
    /// 多傳一個 closure 是為了讓 view 更新完 cell 之後可以通知回 viewModel
    let updateIndex: Bindable<(Int, () -> Void)> = Bindable((0 ,{}))
    let textViewFontName: Bindable<String?> = Bindable(nil)

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
        // 1. call GoogleFont API
        fetchFontUseCase.fetchFonts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fontList):
                
                // 2. register all font
                self.registerAllFont { [weak self] in
                    guard let self = self else { return }
                    // 3. mapping entity to view object
                    self.fontList.value = fontList.map { FontTableViewCellViewObject(entity: $0) }
                    // 4. try to get firt not system font
                    if let index = self.fontList.value.firstIndex(where: { $0.font.fontName != ".SFUI-Regular" }) {
                        // 5. if got the index, update the view objec selected at index
                        self.update(isSelected: true, at: index)
                        // 6. update textview font
                        self.textViewFontName.value = self.fontList.value[index].fontName
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
                    self.didSelected(viewObject: viewObject, at: index)
                }
            }
        } else {
            self.update(isSelected: true, at: index) { [weak self] in
                guard let self = self else { return }
                self.didSelected(viewObject: viewObject, at: index)
            }
        }
    }
}

// MARK: - Helper

private extension MainViewModel {
    
    func didSelected(viewObject: FontTableViewCellViewObject, at index: Int) {
        switch viewObject.status {
        case .notExist:
            self.update(viewObjectAt: index, toStatus: .downloading) { [weak self] in
                guard let self = self else { return }
                self.downloadUseCase.downloadFont(name: viewObject.fontName, url: viewObject.fileURL) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        self.registerFont(fontName: viewObject.fontName, at: index)
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
    
    func registerFont(fontName: String, at index: Int) {
        self.registerFontUseCase.registerFont(fontName: fontName) { result in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) { // for test
                switch result {
                case .success:
                    self.update(viewObjectAt: index, toStatus: .exist)
                    self.textViewFontName.value = fontName
                case .failure(let error):
                    self.update(viewObjectAt: index, toStatus: .notExist)
                    self.handle(error: error)
                }
            }
        }
    }
    
    func update(viewObjectAt index: Int, toStatus status: FontTableViewCellViewObject.Status, completion: @escaping (() -> Void) = {}) {
        let fontEntity = fontList.value[index]
        fontEntity.status = status
        fontEntity.reloadFont()
        updateIndex.value = (index, completion)
    }
    
    /// completion: cell 更新完之後通知用
    func update(isSelected: Bool, at index: Int, completion: @escaping (() -> Void) = {}) {
        fontList.value[index].isSelected = isSelected
        updateIndex.value = (index, completion)
        if isSelected {
            currentSelectedIndex = index
        }
    }
    
    private func handle(error: Error) {
        self.error.value = NSLocalizedString("something is wrong!\n \(error)", comment: "")
    }
}
