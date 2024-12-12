//
//  ProfileEditViewController.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 10.09.2024.
//

import UIKit

final class ProfileEditViewController: UIViewController {
    
    private weak var delegate: ProfileControllerDelegate?
    
    private lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.text = "Имя"
        label.font = UIFont.headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileNameTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = UIColor(named: "YPMediumLightGray")
        text.placeholder = "Введите имя и фамилию"
        text.text = "Поиск имени и фамилии"
        text.delegate = self
        text.layer.cornerRadius = 16
        text.layer.masksToBounds = true
        text.leftViewMode = .always
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        text.addTarget(self, action: #selector(didEnterNameInTextField(_:)), for: .editingDidEndOnExit)
        text.addTarget(self, action: #selector(didEnterNameInTextField(_:)), for: .editingDidEnd)
        text.rightView = profileClearNameButton
        text.rightViewMode = .whileEditing
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let profileClearNameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
        button.backgroundColor = UIColor(named: "YPMediumLightGray")
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(profileClearNameButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "x.mark.circle"), for: .normal)
        return button
    }()
    
    private lazy var profileAvatarPhotoButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "avatarPlug")
        button.addSubview(profileAvatarPhotoLabel)
        button.tintColor = .clear
        button.setImage(image, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(profileAvatarPhotoButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var profileAvatarPhotoLabel: UILabel = {
        let label = UILabel()
        let title = "Поиск \n фото"
        label.backgroundColor = .black.withAlphaComponent(0.6)
        label.text = title
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.text = "Описание"
        label.font = .headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userDescriptionView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "YPMediumLightGray")
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: -11, right: -16)
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 12
        textView.textAlignment = .left
        textView.textContainer.maximumNumberOfLines = 5
        let text = "Поиск описания"
        let style = NSMutableParagraphStyle()
        style.lineSpacing =  3
        let attributes = [NSAttributedString.Key.paragraphStyle : style, .foregroundColor: UIColor(named: "YPBlack"), .font: UIFont.bodyRegular
        ]
        textView.attributedText = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var profileLinkLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.text = "Сайт"
        label.font = UIFont.headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileLinkTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = UIColor(named: "YPMediumLightGray")
        text.placeholder = "Введите ссылку"
        text.text = "Поиск ссылки сайта"
        text.delegate = self
        text.layer.cornerRadius = 16
        text.layer.masksToBounds = true
        text.leftViewMode = .always
        text.addTarget(self, action: #selector(didEnterLinkInTextField(_:)), for: .editingDidEndOnExit)
        text.addTarget(self, action: #selector(didEnterLinkInTextField(_:)), for: .editingDidEnd)
        text.addTarget(self, action: #selector(didStartEditingLinkTextField), for: .editingDidBegin)
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        text.rightView = clearProfileLinkButton
        text.rightViewMode = .whileEditing
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let clearProfileLinkButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
        button.backgroundColor = UIColor(named: "YPMediumLightGray")
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(clearProfileLinkButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "x.mark.circle"), for: .normal)
        return button
    }()
    
    private lazy var profileCloseButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.tintColor = UIColor(named: "YPBlack")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(profileCloseButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPRed")
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let warningLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YPWhite")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var warningLabelTopConstraint: [NSLayoutConstraint] = []
    
    private var profileAvatarPhotoButtonBottomConstraint: [NSLayoutConstraint] = []
    
    private let descriptionViewPlaceholder = "Расскажите о себе"
    
    private var alertPresenter: AlertPresenter?
    private var profileInfo: Profile
    private let fetchProfileService = FetchProfileService.shared
    
    // MARK: Init
    
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
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileInfo(profileInfo)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didEndRedactingProfile(profileInfo)
    }
    
    // MARK: Private
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func profileCloseButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func profileAvatarPhotoButtonTapped() {
        showTextFieldAlert(message: nil)
    }
    
    @objc private func profileClearNameButtonTapped(){
        profileNameTextField.text?.removeAll()
        profileInfo.name.removeAll()
    }
    
    @objc private func clearProfileLinkButtonTapped(){
        profileLinkTextField.text?.removeAll()
        profileInfo.website.removeAll()
    }
    
    @objc private func didStartEditingLinkTextField(){
        liftLinkTextField()
    }
    
    @objc private func didEnterNameInTextField(_ sender: UITextField){
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
    
    @objc private func didEnterLinkInTextField(_ sender: UITextField){
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
    
    // MARK: setupUI
    
    private func setupUI(){
        
        [profileNameLabel, profileNameTextField, profileAvatarPhotoButton, descriptionTitleLabel, userDescriptionView, profileLinkLabel, profileLinkTextField, profileCloseButton, warningLabel, warningLabelContainer].forEach{
            view.addSubview($0)
        }
        
        let constraint = warningLabel.topAnchor.constraint(equalTo: warningLabelContainer.topAnchor)
        warningLabelTopConstraint.append(constraint)
        warningLabelTopConstraint.first?.isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            profileNameLabel.topAnchor.constraint(equalTo: profileAvatarPhotoButton.bottomAnchor, constant: 24),
            profileNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            profileNameTextField.heightAnchor.constraint(equalToConstant: 44),
            profileNameTextField.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8),
            profileNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileClearNameButton.widthAnchor.constraint(equalToConstant: profileClearNameButton.frame.width + 12),
            clearProfileLinkButton.widthAnchor.constraint(equalToConstant: clearProfileLinkButton.frame.width + 12),
            
            profileAvatarPhotoButton.widthAnchor.constraint(equalToConstant: 70),
            profileAvatarPhotoButton.heightAnchor.constraint(equalToConstant: 70),
            profileAvatarPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileAvatarPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            profileAvatarPhotoLabel.topAnchor.constraint(equalTo: profileAvatarPhotoButton.topAnchor),
            profileAvatarPhotoLabel.bottomAnchor.constraint(equalTo: profileAvatarPhotoButton.topAnchor, constant: 70),
            profileAvatarPhotoLabel.leadingAnchor.constraint(equalTo: profileAvatarPhotoButton.leadingAnchor),
            profileAvatarPhotoLabel.trailingAnchor.constraint(equalTo: profileAvatarPhotoButton.trailingAnchor),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: profileNameTextField.bottomAnchor, constant: 24),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            userDescriptionView.heightAnchor.constraint(equalToConstant: 132),
            userDescriptionView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            userDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileLinkLabel.topAnchor.constraint(equalTo: userDescriptionView.bottomAnchor, constant: 24),
            profileLinkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            profileLinkTextField.heightAnchor.constraint(equalToConstant: 44),
            profileLinkTextField.topAnchor.constraint(equalTo: profileLinkLabel.bottomAnchor, constant: 8),
            profileLinkTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileLinkTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileCloseButton.widthAnchor.constraint(equalToConstant: 42),
            profileCloseButton.heightAnchor.constraint(equalToConstant: 42),
            profileCloseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -755),
            profileCloseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            warningLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            warningLabelContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            warningLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            warningLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
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

// MARK: Extensions

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

