//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 10.09.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var profileAvatar = UIImageView(image: UIImage(named: "avatarPlug"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        configProfileAvatar()
    }
    
    private func configProfileAvatar() {
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
    }
}
