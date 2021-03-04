//
//  MainViewController.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/2/27.
//

import UIKit

final class MainViewController: UIViewController {

    // UI element
    private lazy var demoTextView: UITextView = makeDemoTextView()
    private lazy var fontListTableView: UITableView = makeFontListTableView()
    private lazy var buttonStackView: UIStackView = makeButtonStackView()

    // Private property
    private let viewModel: MainViewModelInterface
    
    // Life cycle
    init(viewModel: MainViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        observe(viewModel: viewModel)
        viewModel.viewDidLoad()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Observe ViewModel

extension MainViewController {
    
    func observe(viewModel: MainViewModelInterface) {
        viewModel.fontList.observe(on: self) { target, fontList in
            target.fontListTableView.reloadData()
        }
        
        viewModel.updateIndex.observe(on: self) { target, index in
            let indexPath = IndexPath(row: index, section: 0)
            if case .some = target.fontListTableView.cellForRow(at: indexPath) {
                target.fontListTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        viewModel.error.observe(on: self) { target, error in
            let alert = UIAlertController(title: "Oops!", message: error, preferredStyle: .alert)
            alert.addAction(.init(title: "ok", style: .default, handler: nil))
            target.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fontList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FontTableViewCell.self), for: indexPath) as? FontTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = viewModel.fontList.value[indexPath.row]
        cell.config(with: cellViewModel)
        return cell
    }
}

// MARK: - Target action

private extension MainViewController {
    
    @objc func inputButtonDidPress() {
        demoTextView.isEditable = true
        demoTextView.becomeFirstResponder()
        fontListTableView.isHidden = true
    }
    
    @objc func pickFontButtonDidPress() {
        demoTextView.isEditable = false
        fontListTableView.isHidden = false
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectedRow(at: indexPath.row)
    }
}

// MARK: - UI methods

private extension MainViewController {

    func layoutUI() {
        view.backgroundColor = .white
        
        view.addSubview(fontListTableView)
        NSLayoutConstraint.activate([
            fontListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fontListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fontListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            fontListTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        view.addSubview(demoTextView)
        NSLayoutConstraint.activate([
            demoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            demoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            demoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            demoTextView.bottomAnchor.constraint(equalTo: fontListTableView.topAnchor, constant: -50),
        ])
        
        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: demoTextView.bottomAnchor, constant: 16),
            buttonStackView.bottomAnchor.constraint(equalTo: fontListTableView.topAnchor, constant: -16),
        ])
    }
    
    func makeFontListTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(FontTableViewCell.self, forCellReuseIdentifier: String(describing: FontTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }
    
    func makeDemoTextView() -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 4
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    
    func makeInputButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Input", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(inputButtonDidPress), for: .touchUpInside)
        return button
    }
    
    func makePickFontButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Font", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(pickFontButtonDidPress), for: .touchUpInside)
        return button
    }
    
    func makeButtonStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [makeInputButton(), makePickFontButton()])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }
}
