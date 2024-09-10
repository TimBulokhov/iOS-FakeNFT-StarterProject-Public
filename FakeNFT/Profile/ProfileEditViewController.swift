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
    
    private lazy var descriptionTitleLabel = UILabel()
    private lazy var userDescriptionView = UITextView()
    private let descriptionViewPlaceholder = "Расскажите о себе"
    
    private lazy var linkTitleLabel = UILabel()
    private lazy var linkTextField = UITextField()
    private let clearLinkButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    
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
        
        //Настройка отображения описания пользователя на экране редактирования
        
        descriptionTitleLabel.textColor = UIColor(named: "YPBlack")
        userDescriptionView.backgroundColor = UIColor(named: "YPMediumLightGray")
        userDescriptionView.delegate = self
        userDescriptionView.isScrollEnabled = false
        
        descriptionTitleLabel.text = "Описание"
        descriptionTitleLabel.font = .headline3
        
        userDescriptionView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: -11, right: -16)
        userDescriptionView.layer.masksToBounds = true
        userDescriptionView.layer.cornerRadius = 12
        userDescriptionView.textAlignment = .left
        userDescriptionView.textContainer.maximumNumberOfLines = 5
        
        let text = "Поиск описания"
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing =  3
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          .foregroundColor: UIColor(named: "YPBlack"),
                          .font: UIFont.bodyRegular
        ]
        
        userDescriptionView.attributedText = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
        
        view.addSubview(userDescriptionView)
        view.addSubview(descriptionTitleLabel)
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: profileNameTextField.bottomAnchor, constant: 24),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            userDescriptionView.heightAnchor.constraint(equalToConstant: 132),
            userDescriptionView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            userDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        //Настройка отображения сайта и ссылки пользователя на экране редактирования
        
        linkTitleLabel.textColor = UIColor(named: "YPBlack")
        linkTextField.backgroundColor = UIColor(named: "YPMediumLightGray")
        clearLinkButton.backgroundColor = UIColor(named: "YPMediumLightGray")
        
        linkTitleLabel.text = "Сайт"
        linkTitleLabel.font = UIFont.headline3
        
        linkTextField.placeholder = "Введите ссылку"
        linkTextField.text = "Поиск ссылки сайта"
        linkTextField.delegate = self
        linkTextField.layer.cornerRadius = 16
        linkTextField.layer.masksToBounds = true
        linkTextField.leftViewMode = .always
        
        linkTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        linkTextField.rightView = clearLinkButton
        linkTextField.rightViewMode = .whileEditing
        
        clearLinkButton.contentHorizontalAlignment = .leading
        clearLinkButton.setImage(UIImage(named: "x.mark.circle"), for: .normal)
        
        linkTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        linkTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(linkTextField)
        view.addSubview(linkTitleLabel)
        
        NSLayoutConstraint.activate([
            linkTitleLabel.topAnchor.constraint(equalTo: userDescriptionView.bottomAnchor, constant: 24),
            linkTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            linkTextField.heightAnchor.constraint(equalToConstant: 44),
            linkTextField.topAnchor.constraint(equalTo: linkTitleLabel.bottomAnchor, constant: 8),
            linkTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            linkTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            clearLinkButton.widthAnchor.constraint(equalToConstant: clearLinkButton.frame.width + 12)
        ])
    }
}
