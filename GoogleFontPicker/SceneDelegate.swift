//
//  SceneDelegate.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/2/27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let container = MainSceneDIContainer(
            dependencies: .init(
                networkService: NetworkService.default,
                fontStorage: FileManagerFontDataStorage()
            )
        )
        window.rootViewController = container.makeMainViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
