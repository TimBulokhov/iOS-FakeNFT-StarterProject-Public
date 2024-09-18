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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        configMyNftTitleLabel()
        
    }
    
    private func configMyNftTitleLabel(){
        myNftTitleLabel.textColor = UIColor(named: "YPBlack")
        //myNftTitleLabel.isHidden = true
        myNftTitleLabel.text = "Мои NFT"
        myNftTitleLabel.font = UIFont.bodyBold
        
        myNftTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myNftTitleLabel)
        
        NSLayoutConstraint.activate([
            myNftTitleLabel.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            myNftTitleLabel.centerXAnchor.constraint(equalTo: topViewsContainer.centerXAnchor)
        ])
    }

}
