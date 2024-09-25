//
//  LikedNftViewController.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 25.09.2024.
//

import UIKit

final class LikedNftViewController: UIViewController {
    
    private lazy var topViewsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YPWhite")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var likedNftTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.text = "Избранные NFT"
        label.font = UIFont.bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyLikedNftLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.text = "У Вас ещё нет избранных NFT"
        label.textAlignment = .center
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        setupUI()
    }
    
    private func setupUI() {
        
        NSLayoutConstraint.activate([
            topViewsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topViewsContainer.heightAnchor.constraint(equalToConstant: 42),
            topViewsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topViewsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            likedNftTitleLabel.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            likedNftTitleLabel.centerXAnchor.constraint(equalTo: topViewsContainer.centerXAnchor),
            
            emptyLikedNftLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyLikedNftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            emptyLikedNftLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLikedNftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            
            
        ])
    }
}


