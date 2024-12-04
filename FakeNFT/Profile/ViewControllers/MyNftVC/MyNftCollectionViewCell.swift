//
//  MyNftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 19.09.2024.
//

import UIKit
import Kingfisher

final class MyNftTableViewCell: UITableViewCell {
    
    weak var delegate: TableViewCellDelegate?
    
    private lazy var viewsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        if let nftImageLink = nft?.images.first {
            imageView.kf.setImage(with: URL(string: nftImageLink), placeholder: UIImage(systemName: "photo"))
        }
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .left
        label.font = .bodyBold
        if let nftName = nft?.name {
            label.text = nftName.cutString(at: " ")
        }
        return label
    }()
    
    private lazy var nftAuthorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.font = .caption2
        if let author = nft?.author {
            label.text = "От \(author)"
        }
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .caption2
        if let price = nft?.price {
            let priceString = "\(price) ETH"
            let attributedString = NSMutableAttributedString(string: "Цена" + "\n" + "\(priceString)")
            attributedString.setFont(.bodyBold, forText: "\(priceString)")
            label.attributedText = attributedString
        }
        return label
    }()
    
    private lazy var nftLikeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapNftLikeButton), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.height / 2
        return button
    }()
    
    private lazy var ratingImageView: MyNftRatingImageView = {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let ratingView = MyNftRatingImageView(frame: frame)
        ratingView.backgroundColor = .clear
        ratingView.updateRatingImagesBy(nft?.rating ?? 0)
        return ratingView
    }()
    
    var nft: NftModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.cancelDownloadTask()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    @objc private func didTapNftLikeButton() {
        delegate?.cellLikeButtonTapped(self)
    }
    
    private func setupUI(){
        
        [viewsContainer, nftLikeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [nftImageView, ratingImageView, nftNameLabel, nftAuthorLabel, nftPriceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            viewsContainer.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            viewsContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height),
            
            nftNameLabel.heightAnchor.constraint(equalToConstant: 22),
            nftNameLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            nftNameLabel.bottomAnchor.constraint(equalTo: ratingImageView.topAnchor, constant: -4),
            
            nftAuthorLabel.heightAnchor.constraint(equalToConstant: 20),
            nftAuthorLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            nftAuthorLabel.trailingAnchor.constraint(equalTo: ratingImageView.trailingAnchor),
            nftAuthorLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 4),
            
            nftLikeButton.widthAnchor.constraint(equalToConstant: 40),
            nftLikeButton.heightAnchor.constraint(equalToConstant: 40),
            nftLikeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            nftLikeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            ratingImageView.widthAnchor.constraint(equalToConstant: 68),
            ratingImageView.heightAnchor.constraint(equalToConstant: 12),
            ratingImageView.centerYAnchor.constraint(equalTo: viewsContainer.centerYAnchor),
            ratingImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
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


