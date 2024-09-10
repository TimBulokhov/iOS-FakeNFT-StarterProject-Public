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
    private lazy var profileAvatarPhotoButton = UIButton()
    private lazy var profileAvatarPhotoLabel = UILabel()
    private var profileAvatarPhotoButtonBottomConstraint: [NSLayoutConstraint] = []
    
    private func configProfileEditViewController() {
        
        //Настройка отображения имени пользователя на экране редактирования
        
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
            profileNameLabel.topAnchor.constraint(equalTo: profileAvatarPhotoButton.bottomAnchor, constant: 24),
            profileNameTextField.heightAnchor.constraint(equalToConstant: 44),
            profileNameTextField.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8),
            profileNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileClearNameButton.widthAnchor.constraint(equalToConstant: profileClearNameButton.frame.width + 12)
        ])
        
        //Настройка отображения изображения пользователя на экране редактирования
        
        let image = UIImage(named: "avatarPlug")
        let title = "Поиск \n фото"
        profileAvatarPhotoButton.tintColor = .clear
        profileAvatarPhotoButton.setImage(image, for: .normal)
        profileAvatarPhotoLabel.backgroundColor = .black.withAlphaComponent(0.6)
        
        profileAvatarPhotoLabel.text = title
        profileAvatarPhotoLabel.numberOfLines = 2
        profileAvatarPhotoLabel.textColor = .white
        profileAvatarPhotoLabel.textAlignment = .center
        profileAvatarPhotoLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        
        profileAvatarPhotoLabel.layer.masksToBounds = true
        profileAvatarPhotoLabel.layer.cornerRadius = 35
        profileAvatarPhotoLabel.clipsToBounds = true
        profileAvatarPhotoLabel.contentMode = .scaleAspectFill
        
        profileAvatarPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        profileAvatarPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileAvatarPhotoButton)
        profileAvatarPhotoButton.addSubview(profileAvatarPhotoLabel)
        
        
        let constraint = profileAvatarPhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -602)
        
        profileAvatarPhotoButtonBottomConstraint.append(constraint)
        profileAvatarPhotoButtonBottomConstraint.first?.isActive = true
        
        NSLayoutConstraint.activate([
            profileAvatarPhotoButton.widthAnchor.constraint(equalToConstant: 70),
            profileAvatarPhotoButton.heightAnchor.constraint(equalToConstant: 70),
            profileAvatarPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            profileAvatarPhotoLabel.topAnchor.constraint(equalTo: profileAvatarPhotoButton.topAnchor),
            profileAvatarPhotoLabel.bottomAnchor.constraint(equalTo: profileAvatarPhotoButton.bottomAnchor),
            profileAvatarPhotoLabel.leadingAnchor.constraint(equalTo: profileAvatarPhotoButton.leadingAnchor),
            profileAvatarPhotoLabel.trailingAnchor.constraint(equalTo: profileAvatarPhotoButton.trailingAnchor)
        ])
    }
}
