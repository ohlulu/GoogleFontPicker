//
//  MainSceneDIContainer.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import Foundation

struct MainSceneDIContainer {
    
    private let dependencies: Dependencies
    struct Dependencies {
        let networkService: NetworkServiceSpec
    }
    
    // Initializer
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - Make ViewController

extension MainSceneDIContainer {
    
    func makeMainViewController() -> MainViewController {
        return MainViewController(viewModel: makeMainViewModel())
    }
}

// MARK: - ViewModel

extension MainSceneDIContainer {
    
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel(fetchFontUseCase: makeFetchFontsUseCase())
    }
}

// MARK: - UseCase

extension MainSceneDIContainer {
    
    func makeFetchFontsUseCase() -> FetchFontsUseCase {
        return FetchFontsUseCase(repository: makeFontListRemoteRepository())
    }
}

// MARK: - Repository

extension MainSceneDIContainer {
    
    func makeFontListRemoteRepository() -> FontListRemoteRepositorySpec {
        return FontListRemoteRepository(service: dependencies.networkService)
    }
}
