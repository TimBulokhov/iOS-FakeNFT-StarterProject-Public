//
//  MyNftRatingView.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 19.09.2024.
//

import UIKit
import Kingfisher

final class MyNftRatingImageView: UIImageView {
    
    private let firstNftImageView = UIImageView(image: UIImage(named: "emptyGoldStar"))
    private let secondNftImageView = UIImageView(image: UIImage(named: "emptyGoldStar"))
    private let thirdNftImageView = UIImageView(image: UIImage(named: "emptyGoldStar"))
    private let fourthNftImageView = UIImageView(image: UIImage(named: "emptyGoldStar"))
    private let fifthNftImageView = UIImageView(image: UIImage(named: "emptyGoldStar"))
    private var ratingImageViews: [UIImageView] = []
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ratingImageViews.removeAll()
        ratingImageViews.append(firstNftImageView)
        ratingImageViews.append(secondNftImageView)
        ratingImageViews.append(thirdNftImageView)
        ratingImageViews.append(fourthNftImageView)
        ratingImageViews.append(fifthNftImageView)
        viewAddImageViews()
        configImageVeiwsConstraints()
        setImageViewsContentMode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func viewAddImageViews() {
        for ratingImageView in ratingImageViews {
            ratingImageView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(ratingImageView)
        }
    }
    
    private func configImageVeiwsConstraints() {
        NSLayoutConstraint.activate([
            firstNftImageView.topAnchor.constraint(equalTo: self.topAnchor),
            firstNftImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            firstNftImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            firstNftImageView.widthAnchor.constraint(equalToConstant: firstNftImageView.frame.height),
            
            secondNftImageView.topAnchor.constraint(equalTo: self.topAnchor),
            secondNftImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            secondNftImageView.leadingAnchor.constraint(equalTo: firstNftImageView.trailingAnchor, constant: 2),
            secondNftImageView.widthAnchor.constraint(equalToConstant: firstNftImageView.frame.height),
            
            thirdNftImageView.topAnchor.constraint(equalTo: self.topAnchor),
            thirdNftImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            thirdNftImageView.leadingAnchor.constraint(equalTo: secondNftImageView.trailingAnchor, constant: 2),
            thirdNftImageView.widthAnchor.constraint(equalToConstant: firstNftImageView.frame.height),
            
            fourthNftImageView.topAnchor.constraint(equalTo: self.topAnchor),
            fourthNftImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            fourthNftImageView.leadingAnchor.constraint(equalTo: thirdNftImageView.trailingAnchor, constant: 2),
            fourthNftImageView.widthAnchor.constraint(equalToConstant: firstNftImageView.frame.height),
            
            fifthNftImageView.topAnchor.constraint(equalTo: self.topAnchor),
            fifthNftImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            fifthNftImageView.leadingAnchor.constraint(equalTo: fourthNftImageView.trailingAnchor, constant: 2),
            fifthNftImageView.widthAnchor.constraint(equalToConstant: firstNftImageView.frame.height),
        ])
        
    }
    
    private func setImageViewsContentMode() {
        for ratingImageView in ratingImageViews {
            ratingImageView.clipsToBounds = true
            ratingImageView.contentMode = .scaleAspectFill
        }
    }
    
    func updateRatingImagesBy(_ rating: Int) {
        for index in 0..<rating {
            if ratingImageViews.count - 1 >= index {
                ratingImageViews[index].image = UIImage(named: "goldStar")
            }
        }
        for index in rating..<ratingImageViews.count {
            ratingImageViews[index].image = UIImage(named: "emptyGoldStar")
        }
    }
}
