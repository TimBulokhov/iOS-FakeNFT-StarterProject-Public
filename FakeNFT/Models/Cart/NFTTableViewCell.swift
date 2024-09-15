//
//  NFTTableViewCell.swift
//  FakeNFT
//
//  Created by Мария Шагина on 15.09.2024.
//

import UIKit

class NFTTableViewCell: UITableViewCell {
    
//    MARK: - UI
    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        return nftImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let itemNameLabel = UILabel()
        itemNameLabel.textColor = .black
        itemNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return itemNameLabel
    }()
    
    private lazy var itemPriceLabel: UILabel = {
        let itemPriceLabel = UILabel()
        itemPriceLabel.textColor = .black
        itemPriceLabel.font = UIFont.systemFont(ofSize: 13)
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        return itemPriceLabel
    }()
    
    private lazy var priceLabel: UILabel = {
        let itemCostLabel = UILabel()
        itemCostLabel.textColor = .black
        itemCostLabel.font = UIFont.boldSystemFont(ofSize: 17)
        itemCostLabel.translatesAutoresizingMaskIntoConstraints = false
        return itemCostLabel
    }()
    
    private lazy var ratingLabel: UIImageView = {
        let ratingLabel = UIImageView()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        return ratingLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "deleteCart"), for: .normal)
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    
//    MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.layoutSubviews()
        contentView.addSubview(nftImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(itemPriceLabel)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 144),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 144),
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            itemPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 144),
            itemPriceLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 144),
            priceLabel.topAnchor.constraint(equalTo: itemPriceLabel.bottomAnchor, constant: 2),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    MARK: - methods
    func configure(with item: NFT) {
        nftImageView.image = item.image
        nameLabel.text = item.name
        itemPriceLabel.text = "Цена"
        priceLabel.text = "\(item.price) ETH"
        ratingLabel.image = item.rating
    }
//    MARK: - actions
    //    TO DO :
    @objc
    private func didTapDeleteButton() {}
}
