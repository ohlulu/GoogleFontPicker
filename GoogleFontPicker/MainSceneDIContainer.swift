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
    
    // Persistent storage
    private let fontDataStorage = FileManagerFontDataStorage()
    
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
        return MainViewModel(
            fetchFontUseCase: makeFetchFontsUseCase(),
            registerFontUseCase: makeRegisterFontUseCase(),
            downloadUseCase: makeDownloadUseCase()
        )
    }
}

// MARK: - FetchFontsUseCase

extension MainSceneDIContainer {
    
    func makeFetchFontsUseCase() -> FetchFontsUseCase {
        return FetchFontsUseCase(repository: makeFontListRemoteRepository())
    }
    
    func makeFontListRemoteRepository() -> FontListRemoteRepositorySpec {
        return FontListRemoteRepository(service: dependencies.networkService)
    }
}

// MARK: - RegisterFontUseCase

extension MainSceneDIContainer {
    
    func makeRegisterFontUseCase() -> RegisterFontUseCase {
        return RegisterFontUseCase(repository: makeFontDataRepository())
    }
    
    func makeFontDataRepository() -> FontDataRepository {
        return FontDataRepository(storage: fontDataStorage)
    }
}

extension MainSceneDIContainer {
    
    func makeDownloadUseCase() -> DownloadFontUseCase {
        return DownloadFontUseCase(
            repository: makeFontRepository(),
            storage: fontDataStorage
        )
    }
    
    func makeFontRepository() -> FontRepositorySpec {
        return FontRepository(service: service)
    }
}
