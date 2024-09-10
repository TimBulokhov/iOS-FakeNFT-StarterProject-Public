//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 10.09.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var profileAvatar = UIImageView(image: UIImage(named: "avatarPlug"))
    private lazy var profileName = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        configProfileViewController()
    }
    
    private func configProfileViewController() {
        
        //Настройка отображения изображения профиля
        
        profileAvatar.layer.masksToBounds = true
        profileAvatar.clipsToBounds = true
        profileAvatar.layer.cornerRadius = 35
        profileAvatar.contentMode = .scaleAspectFill
        profileAvatar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileAvatar)
        
        NSLayoutConstraint.activate([
            profileAvatar.widthAnchor.constraint(equalToConstant: 70),
            profileAvatar.heightAnchor.constraint(equalToConstant: 70),
            profileAvatar.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            profileAvatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        //Настройка отображения имени профиля
        
        profileName.textColor = UIColor(named: "YPBlack")
        profileName.font = UIFont.headline3
        profileName.text = "Timofey Bulokhov"
        
        profileName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileName)
        
        NSLayoutConstraint.activate([
            profileName.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            profileName.leadingAnchor.constraint(equalTo: profileAvatar.trailingAnchor, constant: 16),
            profileName.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
}
