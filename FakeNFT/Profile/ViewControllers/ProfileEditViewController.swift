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
    
    private lazy var profileLinkLabel = UILabel()
    private lazy var profileLinkTextField = UITextField()
    private let clearProfileLinkButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    
    private lazy var profileCloseButton = UIButton()
    private let warningLabel = UILabel()
    private let warningLabelContainer = UIView()
    private var warningLabelTopConstraint: [NSLayoutConstraint] = []
    
    private var alertPresenter: AlertPresenter?
    private var profileInfo: Profile
    private let fetchProfileService = FetchProfileService.shared
    
    init(profile: Profile, delegate: ProfileControllerDelegate) {
        profileInfo = profile
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)

        alertPresenter = AlertPresenter(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        configProfileAvatar()
        configProfileWarningLabel()
        configProfileName()
        configProfileDescription()
        configProfileLink()
        configProfileCloseButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileInfo(profileInfo)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didEndRedactingProfile(profileInfo)
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @objc func profileCloseButtonTapped() {
        dismiss(animated: true)
    }
    
    
    @objc func profileAvatarPhotoButtonTapped() {
        showTextFieldAlert(message: nil)
    }
    
    @objc func profileClearNameButtonTapped(){
        profileNameTextField.text?.removeAll()
        profileInfo.name.removeAll()
    }
    
    @objc func clearProfileLinkButtonTapped(){
        profileLinkTextField.text?.removeAll()
        profileInfo.website.removeAll()
    }
    
    @objc func didStartEditingLinkTextField(){
        liftLinkTextField()
    }
    
    @objc func didEnterNameInTextField(_ sender: UITextField){
        
        guard
            let name = sender.text?.trimmingCharacters(in: .whitespaces),
            !name.isEmpty,
            !name.filter({ $0 != Character(" ") }).isEmpty
        else {
            
            let warningText = "Введите имя и фамилию"
            profileClearNameButtonTapped()
            showWarningLabel(with: warningText)
            profileInfo.name.removeAll()
            return
        }
        
        profileNameTextField.text = name
        profileInfo.name = name
    }
    
    @objc func didEnterLinkInTextField(_ sender: UITextField){
        setInitialPositionOfViews()
        
        guard
            let link = sender.text?.trimmingCharacters(in: .whitespaces),
            !link.isEmpty,
            !link.filter({ $0 != Character(" ") }).isEmpty
        else {
            
            let warningText = "Введите ссылку"
            clearProfileLinkButtonTapped()
            showWarningLabel(with: warningText)
            profileInfo.website.removeAll()
            return
        }
        
        profileLinkTextField.text = link
        profileInfo.website = link
    }
    
    private func configProfileName(){
        profileNameLabel.textColor = UIColor(named: "YPBlack")
        profileNameTextField.backgroundColor = UIColor(named: "YPMediumLightGray")
        profileClearNameButton.backgroundColor = UIColor(named: "YPMediumLightGray")
        
        profileNameLabel.text = "Имя"
        profileNameLabel.font = UIFont.headline3
        
        profileNameTextField.placeholder = "Введите имя и фамилию"
        profileNameTextField.text = "Поиск имени и фамилии"
        profileNameTextField.delegate = self
        profileNameTextField.layer.cornerRadius = 16
        profileNameTextField.layer.masksToBounds = true
        profileNameTextField.leftViewMode = .always
        
        profileNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        profileNameTextField.addTarget(self, action: #selector(didEnterNameInTextField(_:)), for: .editingDidEndOnExit)
        profileNameTextField.addTarget(self, action: #selector(didEnterNameInTextField(_:)), for: .editingDidEnd)
        profileNameTextField.rightView = profileClearNameButton
        profileNameTextField.rightViewMode = .whileEditing
        
        profileClearNameButton.contentHorizontalAlignment = .leading
        profileClearNameButton.addTarget(self, action: #selector(profileClearNameButtonTapped), for: .touchUpInside)
        profileClearNameButton.setImage(UIImage(named: "x.mark.circle"), for: .normal)
        
        profileNameTextField.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileNameTextField)
        view.addSubview(profileNameLabel)
        
        NSLayoutConstraint.activate([
            profileNameLabel.topAnchor.constraint(equalTo: profileAvatarPhotoButton.bottomAnchor, constant: 24),
            profileNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            profileNameTextField.heightAnchor.constraint(equalToConstant: 44),
            profileNameTextField.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8),
            profileNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileClearNameButton.widthAnchor.constraint(equalToConstant: profileClearNameButton.frame.width + 12)
        ])
    }
    
    private func configProfileAvatar() {
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
        
        profileAvatarPhotoButton.layer.masksToBounds = true
        profileAvatarPhotoButton.layer.cornerRadius = 35
        profileAvatarPhotoButton.clipsToBounds = true
        profileAvatarPhotoButton.contentMode = .scaleAspectFill
        
        profileAvatarPhotoButton.addTarget(self, action: #selector(profileAvatarPhotoButtonTapped), for: .touchUpInside)
        profileAvatarPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        profileAvatarPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileAvatarPhotoButton)
        profileAvatarPhotoButton.addSubview(profileAvatarPhotoLabel)
        
        NSLayoutConstraint.activate([
            profileAvatarPhotoButton.widthAnchor.constraint(equalToConstant: 70),
            profileAvatarPhotoButton.heightAnchor.constraint(equalToConstant: 70),
            profileAvatarPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileAvatarPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            profileAvatarPhotoLabel.topAnchor.constraint(equalTo: profileAvatarPhotoButton.topAnchor),
            profileAvatarPhotoLabel.bottomAnchor.constraint(equalTo: profileAvatarPhotoButton.topAnchor, constant: 70),
            profileAvatarPhotoLabel.leadingAnchor.constraint(equalTo: profileAvatarPhotoButton.leadingAnchor),
            profileAvatarPhotoLabel.trailingAnchor.constraint(equalTo: profileAvatarPhotoButton.trailingAnchor)
        ])
    }
    
    private func configProfileDescription() {
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
    }
    
    private func configProfileLink(){
        profileLinkLabel.textColor = UIColor(named: "YPBlack")
        profileLinkTextField.backgroundColor = UIColor(named: "YPMediumLightGray")
        clearProfileLinkButton.backgroundColor = UIColor(named: "YPMediumLightGray")
        
        profileLinkLabel.text = "Сайт"
        profileLinkLabel.font = UIFont.headline3
        
        profileLinkTextField.placeholder = "Введите ссылку"
        profileLinkTextField.text = "Поиск ссылки сайта"
        profileLinkTextField.delegate = self
        profileLinkTextField.layer.cornerRadius = 16
        profileLinkTextField.layer.masksToBounds = true
        profileLinkTextField.leftViewMode = .always
        
        profileLinkTextField.addTarget(self, action: #selector(didEnterLinkInTextField(_:)), for: .editingDidEndOnExit)
        profileLinkTextField.addTarget(self, action: #selector(didEnterLinkInTextField(_:)), for: .editingDidEnd)
        profileLinkTextField.addTarget(self, action: #selector(didStartEditingLinkTextField), for: .editingDidBegin)
        
        profileLinkTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        profileLinkTextField.rightView = clearProfileLinkButton
        profileLinkTextField.rightViewMode = .whileEditing
        
        clearProfileLinkButton.contentHorizontalAlignment = .leading
        clearProfileLinkButton.addTarget(self, action: #selector(clearProfileLinkButtonTapped), for: .touchUpInside)
        clearProfileLinkButton.setImage(UIImage(named: "x.mark.circle"), for: .normal)
        
        profileLinkLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLinkTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileLinkTextField)
        view.addSubview(profileLinkLabel)
        
        NSLayoutConstraint.activate([
            profileLinkLabel.topAnchor.constraint(equalTo: userDescriptionView.bottomAnchor, constant: 24),
            profileLinkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            profileLinkTextField.heightAnchor.constraint(equalToConstant: 44),
            profileLinkTextField.topAnchor.constraint(equalTo: profileLinkLabel.bottomAnchor, constant: 8),
            profileLinkTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileLinkTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            clearProfileLinkButton.widthAnchor.constraint(equalToConstant: clearProfileLinkButton.frame.width + 12)
        ])
    }
    
    private func configProfileCloseButton() {
        let image = UIImage(named: "close")
        profileCloseButton.tintColor = UIColor(named: "YPBlack")
        
        profileCloseButton.setImage(image, for: .normal)
        profileCloseButton.addTarget(self, action: #selector(profileCloseButtonTapped), for: .touchUpInside)
    
        profileCloseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileCloseButton)
        
        NSLayoutConstraint.activate([
            profileCloseButton.widthAnchor.constraint(equalToConstant: 42),
            profileCloseButton.heightAnchor.constraint(equalToConstant: 42),
            profileCloseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -780),
            profileCloseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    
    private func configProfileWarningLabel(){
        warningLabelContainer.backgroundColor = UIColor(named: "YPWhite")
        warningLabel.textColor = UIColor(named: "YPRed")
        warningLabel.font = UIFont.systemFont(ofSize: 17)
        warningLabel.numberOfLines = 2
        warningLabel.textAlignment = .center
        
        view.addSubview(warningLabel)
        view.addSubview(warningLabelContainer)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            warningLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            warningLabelContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            warningLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            warningLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let constraint = warningLabel.topAnchor.constraint(equalTo: warningLabelContainer.topAnchor)
        
        warningLabelTopConstraint.append(constraint)
        
        warningLabelTopConstraint.first?.isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func showWarningLabel(with text: String){
        
        warningLabel.text = text
        isTextFieldAndSaveButtonEnabled(bool: false)
        
        DispatchQueue.main.async {
            
            if let constraint = self.warningLabelTopConstraint.first {
                
                UIView.animate(withDuration: 0.5, delay: 0.03) {
                    constraint.constant = -50
                    self.view.layoutIfNeeded()
                    
                } completion: { isCompleted in
                    
                    UIView.animate(withDuration: 0.4, delay: 2) {
                        constraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.1, execute: {
            
            self.isTextFieldAndSaveButtonEnabled(bool: true)
        })
    }
    
    private func isTextFieldAndSaveButtonEnabled(bool: Bool){
        profileAvatarPhotoButton.isEnabled = bool
        profileNameTextField.isEnabled = bool
        userDescriptionView.isEditable = bool
    }
    
    
    private func clearTextView() {
        userDescriptionView.text = "Расскажите о себе"
        userDescriptionView.textColor = UIColor.lightGray
        profileInfo.description.removeAll()
    }
    
    func updateProfileInfo(_ profile: Profile) {
        profileNameTextField.text = profile.name
        profileLinkTextField.text = profile.website
        
        updateProfileAvatarWith(url: profile.avatar)
        updateUserDescription(profile.description)
    }
    
    private func updateUserDescription(_ description: String?) {
        userDescriptionView.text = description
        textViewDidEndEditing(userDescriptionView)
    }
    
    private func updateProfileAvatarWith(url: String) {
        let title = "Сменить \n фото"
        profileAvatarPhotoLabel.text = title
        
        guard let avatarUrl = URL(string: url) else {
            return
        }
        
        profileAvatarPhotoButton.imageView?.kf.setImage(with: avatarUrl) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
                
            case .success(let value):
                self.profileInfo.avatar = url
                profileAvatarPhotoButton.setImage(value.image, for: .normal)
                
            case .failure(let error):
                self.showTextFieldAlert(message: "\n Ошибка: \(error.errorCode)")
                self.showWarningLabel(with: "Не удалось определить." + "\n" + "Попробуйте другую ссылку")
                return
            }
        }
    }
    
    private func showTextFieldAlert(message: String?) {
        let placeHolder = "Введите ссылку"
        let model = AlertModel(
            title: "Изменение фото", message: message,
            closeAlertTitle: "Отмена",
            completionTitle: "Сохранить") {}
        
        alertPresenter?.textFieldAlert(model: model, placeHolder: placeHolder, delegate: self)
    }
    
    private func liftLinkTextField() {
        UIView.animate(withDuration: 0.3) {
            
            if let constraint = self.profileAvatarPhotoButtonBottomConstraint.first {
                constraint.constant = -750
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func liftDescriptionTextView() {
        UIView.animate(withDuration: 0.3) {
            
            if let constraint = self.profileAvatarPhotoButtonBottomConstraint.first {
                constraint.constant = -647
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setInitialPositionOfViews() {
        UIView.animate(withDuration: 0.5) {
            
            if let constraint = self.profileAvatarPhotoButtonBottomConstraint.first {
                constraint.constant = -602
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ProfileEditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 38
        
        let currentString = (textField.text ?? "") as NSString
        
        let newString = currentString.replacingCharacters(in: range, with: string).trimmingCharacters(in: .newlines)
        
        guard newString.count <= maxLength else {
            
            showWarningLabel(with: "Ограничение \(38) слов")
            return false
        }
        
        return true
    }
}

extension ProfileEditViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let maxLength = 140
        
        let currentString = (textView.text ?? "") as NSString
        
        let newString = currentString.replacingCharacters(in: range, with: text).trimmingCharacters(in: .newlines)
        
        guard newString.count <= maxLength else {
            return false
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        setInitialPositionOfViews()
        
        let description = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            !description.isEmpty,
            !description.filter({ $0 != Character(" ") }).isEmpty
        else {
        
            clearTextView()
            return
        }
        
        textView.text = description
        profileInfo.description = description
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if let text = textView.text,
           text == descriptionViewPlaceholder {
            textView.text.removeAll()
        }
        
        textView.textColor = UIColor(named: "YPBlack")
        liftDescriptionTextView()
    }
}

extension ProfileEditViewController: TextFieldAlertDelegate {
    
    func alertSaveTextButtonTappep(text: String?) {
        
        guard
            let link = text?.trimmingCharacters(in: .whitespaces),
            !link.filter({$0 != Character(" ")}).isEmpty
        else {
            showTextFieldAlert(message: nil)
            showWarningLabel(with: "Введите ссылку")
            return
        }
        updateProfileAvatarWith(url: link)
    }
}

