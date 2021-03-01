//
//  MainViewModel.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import Foundation

protocol MainViewModelInput {
    func viewDidLoad()
}

protocol MainViewModelOutput {
    var error: Observable<String> { get }
    var fontList: Observable<[FontEntity]> { get }
}

typealias MainViewModelInterface =  MainViewModelInput & MainViewModelOutput

final class MainViewModel: MainViewModelInterface {
    
    // Output
    let error: Observable<String> = Observable("")
    let fontList: Observable<[FontEntity]> = Observable([])

    // Property
    private let fetchFontUseCase: FetchFontsUseCase

    // Life cycle
    init(fetchFontUseCase: FetchFontsUseCase) {
        self.fetchFontUseCase = fetchFontUseCase
    }
}

// MARK: - MainViewModelInput

extension MainViewModel {
    
    func viewDidLoad() {
        fetchFontUseCase.fetchFonts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fontList):
                self.fontList.value = fontList
            case .failure(let error):
                self.handle(error: error)
            }
        }
    }
}

// MARK: - Output

extension MainViewModel {
    
}

// MARK: - Helper

private extension MainViewModel {
    private func handle(error: Error) {
        self.error.value = NSLocalizedString("something is wrong: \(error)", comment: "")
    }
}