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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        configTopViewsContainer()
        configMyNftTitleLabel()
        configEmptyNftLabel()
        
    }
    
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

}
