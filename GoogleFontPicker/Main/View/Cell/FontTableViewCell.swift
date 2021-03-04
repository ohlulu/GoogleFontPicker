//
//  FontTableViewCell.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import UIKit

final class FontTableViewCell: UITableViewCell {
    
    // UI elements
    private lazy var baseView = makeBaseView()
    private lazy var familyNameLabel: UILabel = makeFamilyLabel()
    private lazy var downloadImageView: UIImageView = makeDownloadImageView()
    private lazy var loadingIndicator: UIActivityIndicatorView = makeLoadingActivity()
    private lazy var selectedIndicator: UIView = makeSelectedIndicator()
    
    // Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FontTableViewCell {
    
    func config(with viewModel: FontTableViewCellViewObject) {
        familyNameLabel.text = viewModel.familyName
        familyNameLabel.font = viewModel.font.withSize(18)
        
        if viewModel.isSelected {
            baseView.layer.borderWidth = 2
        } else {
            baseView.layer.borderWidth = 0
        }
        
        switch viewModel.status {
        case .notExist:
            downloadImageView.isHidden = false
        case .downloading:
            loadingIndicator.startAnimating()
            downloadImageView.isHidden = true
        case .exist:
            downloadImageView.isHidden = true
        }
    }
}

// MARK: - Layout

extension FontTableViewCell {
    
    func layoutUI() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        contentView.addSubview(baseView)
        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            baseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            baseView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            baseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        
        baseView.addSubview(familyNameLabel)
        NSLayoutConstraint.activate([
            familyNameLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 12),
            familyNameLabel.topAnchor.constraint(equalTo: baseView.topAnchor),
            familyNameLabel.bottomAnchor.constraint(equalTo: baseView.bottomAnchor)
        ])
        
        baseView.addSubview(downloadImageView)
        NSLayoutConstraint.activate([
            downloadImageView.leadingAnchor.constraint(equalTo: familyNameLabel.trailingAnchor, constant: 8),
            downloadImageView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -12),
            downloadImageView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
            downloadImageView.heightAnchor.constraint(equalToConstant: 24),
            downloadImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        baseView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: downloadImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: downloadImageView.centerYAnchor)
        ])
        
//        baseView.addSubview(selectedIndicator)
    }
    
    func makeBaseView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 2
        view.layer.maskedCorners = CACornerMask(rawValue: UIRectCorner.allCorners.rawValue)
        view.layer.borderColor = UIColor.green.cgColor
        return view
    }
    
    func makeFamilyLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGray5
        return label
    }
    
    func makeDownloadImageView() -> UIImageView {
        let imageView = UIImageView(frame: .init(origin: .zero, size: .init(width: 24, height: 24)))
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .yellow
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = CACornerMask(rawValue: UIRectCorner.allCorners.rawValue)
        return imageView
    }
    
    func makeLoadingActivity() -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = .darkGray
        return indicatorView
    }
    
    func makeSelectedIndicator() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 2
        view.layer.maskedCorners = CACornerMask(rawValue: UIRectCorner.allCorners.rawValue)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.green.cgColor
        return view
    }
}
