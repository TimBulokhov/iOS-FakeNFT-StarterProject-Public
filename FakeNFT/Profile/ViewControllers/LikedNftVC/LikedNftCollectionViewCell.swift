//
//  LikedNftCell.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 25.09.2024.
//

import UIKit
import Kingfisher

final class LikedNftCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    
    private lazy var viewsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var likedNftImageView: UIImageView = {
        let imageView = UIImageView()
        if let nftImageLink = nft?.images.first {
            imageView.kf.setImage(with: URL(string: nftImageLink), placeholder: UIImage(systemName: "photo"))
        }
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var likedNftNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .left
        label.font = .bodyBold
        if let nftName = nft?.name {
            label.text = nftName.cutString(at: " ")
        }
        return label
    }()
    
    private lazy var likedNftPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        if let price = nft?.price {
            label.text = "\(price) ETH"
        }
        return label
    }()
    
    private lazy var likedNftLikeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.height / 2
        return button
    }()
    
    private lazy var likedNftRatingImageView: MyNftRatingImageView = {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let ratingView = MyNftRatingImageView(frame: frame)
        ratingView.backgroundColor = .clear
        ratingView.updateRatingImagesBy(nft?.rating ?? 0)
        return ratingView
    }()
    
    var nft: NftModel?
    
    // MARK: Extensions
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likedNftRatingImageView.kf.indicatorType = .activity
        likedNftRatingImageView.kf.cancelDownloadTask()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapLikeButton() {
        delegate?.cellLikeButtonTapped(self)
    }
    
    // MARK: setupUI
    
    private func setupUI(){
        
        [viewsContainer, likedNftLikeButton].forEach {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    contentView.addSubview($0)
                }
        
        [likedNftImageView, likedNftRatingImageView, likedNftNameLabel, likedNftPriceLabel].forEach {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    viewsContainer.addSubview($0)
                }
        
        NSLayoutConstraint.activate([
            viewsContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            likedNftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            likedNftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            likedNftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            likedNftImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height),
            
            likedNftLikeButton.widthAnchor.constraint(equalToConstant: 40),
            likedNftLikeButton.heightAnchor.constraint(equalToConstant: 40),
            likedNftLikeButton.topAnchor.constraint(equalTo: likedNftImageView.topAnchor),
            likedNftLikeButton.trailingAnchor.constraint(equalTo: likedNftImageView.trailingAnchor),
            
            likedNftRatingImageView.widthAnchor.constraint(equalToConstant: 68),
            likedNftRatingImageView.heightAnchor.constraint(equalToConstant: 12),
            likedNftRatingImageView.centerYAnchor.constraint(equalTo: viewsContainer.centerYAnchor),
            likedNftRatingImageView.leadingAnchor.constraint(equalTo: likedNftImageView.trailingAnchor, constant: 12),
            
            likedNftNameLabel.heightAnchor.constraint(equalToConstant: 22),
            likedNftNameLabel.leadingAnchor.constraint(equalTo: likedNftRatingImageView.leadingAnchor),
            likedNftNameLabel.bottomAnchor.constraint(equalTo: likedNftRatingImageView.topAnchor, constant: -4),
            
            likedNftPriceLabel.heightAnchor.constraint(equalToConstant: 20),
            likedNftPriceLabel.topAnchor.constraint(equalTo: likedNftRatingImageView.bottomAnchor, constant: 8),
            likedNftPriceLabel.leadingAnchor.constraint(equalTo: likedNftRatingImageView.leadingAnchor)
            
        ])
    }
    
    func setLikeImageForLikeButton() {
        likedNftLikeButton.setImage(UIImage(named: "redHeart"), for: .normal)
    }
}



