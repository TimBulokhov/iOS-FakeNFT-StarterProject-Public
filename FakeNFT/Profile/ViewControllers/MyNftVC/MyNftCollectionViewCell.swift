//
//  MyNftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 19.09.2024.
//

import UIKit
import Kingfisher

final class MyNftCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    
    private lazy var viewsContainer = UIView()
    private lazy var nftImageView = UIImageView()
    private lazy var nftNameLabel = UILabel()
    private lazy var nftAuthorLabel = UILabel()
    private lazy var nftPriceLabel = UILabel()
    private lazy var nftLikeButton = UIButton()
    
    private lazy var ratingImageView: MyNftRatingImageView = {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        return MyNftRatingImageView(frame: frame)
    }()
    
    var nft: NftModel?
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.cancelDownloadTask()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configViewsContainer()
        configNftImageView()
        configNftLikeButton()
        configMyNftRatingImageView()
        configNftTextLabels()
        configNftPriceLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    @objc private func didTapNftLikeButton() {
        delegate?.cellLikeButtonTapped(self)
    }
    
    private func configViewsContainer(){
        viewsContainer.backgroundColor = .clear
        viewsContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewsContainer)
        
        NSLayoutConstraint.activate([
            viewsContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func configNftImageView() {
        if let nftImageLink = nft?.images.first {
            nftImageView.kf.setImage(with: URL(string: nftImageLink), placeholder: UIImage(systemName: "photo"))
        }
        nftImageView.layer.masksToBounds = true
        nftImageView.layer.cornerRadius = 12
        viewsContainer.addSubview(nftImageView)
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height)
        ])
    }
    
    private func configNftLikeButton(){
        nftLikeButton.addTarget(self, action: #selector(didTapNftLikeButton), for: .touchUpInside)
        nftLikeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nftLikeButton)
        
        NSLayoutConstraint.activate([
            nftLikeButton.widthAnchor.constraint(equalToConstant: 40),
            nftLikeButton.heightAnchor.constraint(equalToConstant: 40),
            nftLikeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            nftLikeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor)
        ])
        nftLikeButton.layer.masksToBounds = true
        nftLikeButton.layer.cornerRadius = nftLikeButton.frame.height / 2
    }
    
    private func configMyNftRatingImageView() {
        ratingImageView.backgroundColor = .clear
        ratingImageView.updateRatingImagesBy(nft?.rating ?? 0)
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        viewsContainer.addSubview(ratingImageView)
        
        NSLayoutConstraint.activate([
            ratingImageView.widthAnchor.constraint(equalToConstant: 68),
            ratingImageView.heightAnchor.constraint(equalToConstant: 12),
            ratingImageView.centerYAnchor.constraint(equalTo: viewsContainer.centerYAnchor),
            ratingImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20)
        ])
    }
    
    private func configNftTextLabels(){
        nftNameLabel.textColor = UIColor(named: "YPBlack")
        nftAuthorLabel.textColor = UIColor(named: "YPBlack")
        nftNameLabel.textAlignment = .left
        nftNameLabel.font = .bodyBold
        nftAuthorLabel.font = .caption2
        if let author = nft?.author, let nftName = nft?.name {
            nftNameLabel.text = nftName.cutString(at: " ")
            nftAuthorLabel.text = "От \(author)"
        }
        nftNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nftAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsContainer.addSubview(nftNameLabel)
        viewsContainer.addSubview(nftAuthorLabel)
        
        NSLayoutConstraint.activate([
            nftNameLabel.heightAnchor.constraint(equalToConstant: 22),
            nftNameLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            nftNameLabel.bottomAnchor.constraint(equalTo: ratingImageView.topAnchor, constant: -4),
            nftAuthorLabel.heightAnchor.constraint(equalToConstant: 20),
            nftAuthorLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            nftAuthorLabel.trailingAnchor.constraint(equalTo: ratingImageView.trailingAnchor),
            nftAuthorLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 4)
        ])
    }
    
    private func configNftPriceLabel() {
        nftPriceLabel.textColor = UIColor(named: "YPBlack")
        nftPriceLabel.textAlignment = .left
        nftPriceLabel.numberOfLines = 2
        nftPriceLabel.font = .caption2
        if let price = nft?.price {
            let priceString = "\(price) ETH"
            let attributedString = NSMutableAttributedString(string: "Цена" + "\n" + "\(priceString)")
            attributedString.setFont(.bodyBold, forText: "\(priceString)")
            nftPriceLabel.attributedText = attributedString
        }
        
        nftPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsContainer.addSubview(nftPriceLabel)
        
        NSLayoutConstraint.activate([
            nftPriceLabel.topAnchor.constraint(equalTo: viewsContainer.topAnchor, constant: 33),
            nftPriceLabel.bottomAnchor.constraint(equalTo: viewsContainer.bottomAnchor, constant: -33),
            nftPriceLabel.trailingAnchor.constraint(equalTo: viewsContainer.trailingAnchor),
            nftPriceLabel.leadingAnchor.constraint(lessThanOrEqualTo: nftImageView.trailingAnchor, constant: 137)
        ])
    }
    
    func setLikeImageForLikeButton() {
        nftLikeButton.setImage(UIImage(named: "redHeart"), for: .normal)
    }
    
    func removeLikeImageForLikeButton() {
        nftLikeButton.setImage(UIImage(named: "whiteHeart"), for: .normal)
    }

}

// MARK: Extensions

extension NSMutableAttributedString {
    
    func setFont(_ font: UIFont, forText text: String) {
        let range = self.mutableString.range(of: text, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}

extension String {
    func cutString(at character: Character) -> String {
        var newString = ""
        for char in self {
            if char != character {
                newString.append(char)
            } else {
                break
            }
        }
        return newString
    }
}
