//
//  CatalogueTableViewCell.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 09.09.2024.
//

import Foundation
import UIKit
import Kingfisher

final class CatalogueTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CatalogueTableViewCell"
    
    private let coverOfSection: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = false
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(coverOfSection)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            coverOfSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            coverOfSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverOfSection.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverOfSection.heightAnchor.constraint(equalToConstant: 140),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: coverOfSection.bottomAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    func configureCell(withTitle title: String, nftCount: Int, imageURL: URL) {
        titleLabel.text = "\(title) (\(nftCount))"
        coverOfSection.kf.setImage(with: imageURL)
    }
}
