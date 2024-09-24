//
//  NFTTableViewCell.swift
//  FakeNFT
//
//  Created by Мария Шагина on 16.09.2024.
//

import UIKit
import Kingfisher

protocol CartCellDelegate: AnyObject {
    func showDeleteView(index: Int)
}

class NFTTableViewCell: UITableViewCell {
    
    static let identifier = "NFTTableViewCell"
    
    var imageURL: URL? {
        didSet {
            guard let url = imageURL else {
                return nftImageView.kf.cancelDownloadTask()
            }
            
            nftImageView.kf.setImage(with: url)
        }
    }
    
    weak var delegate: CartCellDelegate?
    var indexCell: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NFTTableViewCell.identifier)
        addViews()
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - UI
    private lazy var formattedPrice: NumberFormatter = {
        let formatted = NumberFormatter()
        formatted.locale = Locale(identifier: "ru_RU")
        formatted.numberStyle = .decimal
        return formatted
    }()
    
    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.layer.cornerRadius = 16
        nftImageView.layer.masksToBounds = true
        nftImageView.image = UIImage(named: "april")
        return nftImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let itemNameLabel = UILabel()
        itemNameLabel.textColor = .black
        itemNameLabel.text = "April"
        itemNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
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
        itemCostLabel.text = "1,78 ETH"
        itemCostLabel.font = UIFont.boldSystemFont(ofSize: 17)
        itemCostLabel.translatesAutoresizingMaskIntoConstraints = false
        return itemCostLabel
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let nftPriceLabel = UILabel()
        nftPriceLabel.text = "Цена"
        nftPriceLabel.font = UIFont.systemFont(ofSize: 13)
        return nftPriceLabel
    }()
    
    private lazy var ratingLabel: UIImageView = {
        let ratingLabel = UIImageView()
        return ratingLabel
    }()
    
    private lazy var ratingStack: UIStackView = {
        let ratingStack = UIStackView()
        ratingStack.axis = .horizontal
        ratingStack.spacing = 4
        return ratingStack
    }()
    
    private lazy var removeCartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "deleteCart"), for: .normal)
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    
    //    MARK: - methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addViews() {
        [nftImageView, nameLabel, nftPriceLabel, priceLabel, ratingStack].forEach(setupView(_:))
        [removeCartButton].forEach(contentView.setupView(_:))
    }
    
    private func setupUI() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            ratingStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            ratingStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftPriceLabel.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: nftPriceLabel.bottomAnchor, constant: 2),
            removeCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeCartButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func configure(with item: NFTModel) {
        if let formattedPrice = formattedPrice.string(from: NSNumber(value: item.price)) {
            priceLabel.text = "\(formattedPrice) ETH"
        }
        nameLabel.text = item.name
        itemPriceLabel.text = "Цена"
        for rating in ratingStack.arrangedSubviews {
            rating.removeFromSuperview()
        }
        
        let rating = item.rating
        
        for _ in 0..<rating {
            let ratingStar = UIImageView(image: UIImage(named: "star_yellow"))
            ratingStack.addArrangedSubview(ratingStar)
        }
        for _ in rating..<5 {
            let emptyStar =  UIImageView(image: UIImage(named: "star"))
            ratingStack.addArrangedSubview(emptyStar)
        }
    }
    //    MARK: - actions
    
    @objc
    private func didTapDeleteButton() {
        guard let indexCell else { return }
        delegate?.showDeleteView(index: indexCell)
    }
}
