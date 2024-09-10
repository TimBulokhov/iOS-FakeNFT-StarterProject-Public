//
//  ProfileEditViewController.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 10.09.2024.
//

import UIKit

final class ProfileEditViewController: UIViewController {
    
    private weak var delegate: ProfileControllerDelegate?
    
    private lazy var profileNameLabel = UILabel()
    private lazy var profileNameTextField = UITextField()
    private let profileClearNameButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    
    private func configProfileEditViewController() {
        profileNameLabel.textColor = UIColor(named: "YPBlack")
        profileNameLabel.text = "Имя"
        profileNameLabel.font = UIFont.headline3
        profileNameTextField.backgroundColor = UIColor(named: "YPMediumLightGray")
        profileClearNameButton.backgroundColor = UIColor(named: "YPMediumLightGray")
        
        profileNameTextField.placeholder = "Введите имя и фамилию"
        profileNameTextField.text = "Поиск имени и фамилии"
        profileNameTextField.delegate = self
        profileNameTextField.layer.cornerRadius = 16
        profileNameTextField.layer.masksToBounds = true
        profileNameTextField.leftViewMode = .always
        
        profileNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        profileNameTextField.rightView = profileClearNameButton
        profileNameTextField.rightViewMode = .whileEditing
        
        profileClearNameButton.contentHorizontalAlignment = .leading
        profileClearNameButton.setImage(UIImage(named: "x.mark.circle"), for: .normal)
        
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileClearNameButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileNameTextField)
        view.addSubview(profileNameLabel)
        
        NSLayoutConstraint.activate([
            profileNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            profileNameTextField.heightAnchor.constraint(equalToConstant: 44),
            profileNameTextField.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8),
            profileNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileClearNameButton.widthAnchor.constraint(equalToConstant: profileClearNameButton.frame.width + 12)
        ])
    }
}
