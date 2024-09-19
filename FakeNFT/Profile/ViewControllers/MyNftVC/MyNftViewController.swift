//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 18.09.2024.
//

import UIKit

final class MyNftViewController: UIViewController {
    
    private lazy var myNftTitleLabel = UILabel()
    private lazy var topViewsContainer = UIView()
    private lazy var emptyNftLabel = UILabel()
    private lazy var nftSortingButton = UIButton()
    private lazy var nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let nftCollectionViewCellIdentifier = "nftCollectionCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        configTopViewsContainer()
        configMyNftTitleLabel()
        configEmptyNftLabel()
        configNftSortingButton()
        
    }
    
    @objc private func nftSortingButtonTapped() {
        
    }
    
    // MARK: topViewsContainer
    
    private func configTopViewsContainer() {
        topViewsContainer.backgroundColor = UIColor(named: "YPWhite")
        topViewsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topViewsContainer)
        
        NSLayoutConstraint.activate([
            topViewsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topViewsContainer.heightAnchor.constraint(equalToConstant: 42),
            topViewsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topViewsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    // MARK: myNftTitleLabel
    
    private func configMyNftTitleLabel(){
        myNftTitleLabel.textColor = UIColor(named: "YPBlack")
        myNftTitleLabel.isHidden = true
        myNftTitleLabel.text = "Мои NFT"
        myNftTitleLabel.font = UIFont.bodyBold
        
        myNftTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myNftTitleLabel)
        
        NSLayoutConstraint.activate([
            myNftTitleLabel.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            myNftTitleLabel.centerXAnchor.constraint(equalTo: topViewsContainer.centerXAnchor)
        ])
    }
    
    // MARK: emptyNftLabel
    
    private func configEmptyNftLabel(){
        emptyNftLabel.textColor = UIColor(named: "YPBlack")
        emptyNftLabel.isHidden = true
        
        emptyNftLabel.text = "У вас ещё нет NFT"
        emptyNftLabel.textAlignment = .center
        emptyNftLabel.font = .bodyBold
        emptyNftLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyNftLabel)
        
        NSLayoutConstraint.activate([
            emptyNftLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyNftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            emptyNftLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        ])
    }
    
    // MARK: nftSortingButton
    
    private func configNftSortingButton() {
        let image = UIImage(named: "sortButtonImage")
        nftSortingButton.tintColor = UIColor(named: "YPBlack")
        nftSortingButton.isHidden = true
        
        nftSortingButton.setImage(image, for: .normal)
        nftSortingButton.addTarget(self, action: #selector(nftSortingButtonTapped), for: .touchUpInside)
        
        nftSortingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nftSortingButton)
        
        NSLayoutConstraint.activate([
            nftSortingButton.widthAnchor.constraint(equalToConstant: 24),
            nftSortingButton.heightAnchor.constraint(equalToConstant: 24),
            nftSortingButton.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            nftSortingButton.trailingAnchor.constraint(equalTo: topViewsContainer.trailingAnchor, constant: -9)
        ])
    }
    
    // MARK: nftCollectionView
    
    private func configNftCollectionView() {
        //nftCollectionView.dataSource = self
        //nftCollectionView.delegate = self
        nftCollectionView.backgroundColor = .clear
        
        nftCollectionView.register(MyNftCollectionViewCell.self, forCellWithReuseIdentifier: nftCollectionViewCellIdentifier)
        
        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nftCollectionView)
        
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: topViewsContainer.bottomAnchor),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}

// MARK: Extensions
