//
//  MainViewController.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/2/27.
//

import UIKit

final class MainViewController: UIViewController {

    // UI element

    // Life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewModel delegate

extension MainViewController {}

// MARK: - Target action

private extension MainViewController {}

// MARK: - Helper

private extension MainViewController {}

// MARK: - UI methods

private extension MainViewController {

    func layoutUI() {
        view.backgroundColor = .white
    }
}
