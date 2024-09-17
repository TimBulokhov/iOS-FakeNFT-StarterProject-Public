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
    private lazy var profileDescription = UITextView()
    private lazy var myNftTableView = UITableView()
    private let myNftCellIdentifier = "tableCellIdentifier"
    private let myNftTableViewCells = ["Мои NFT", "Избранные NFT", "О разработчике"]
    private var nftIdArray: [String] = []
    private var likedNFTIdArray: [String] = []
    private lazy var profileEditButton = UIButton(type: .system)
    private var profile: Profile?
    private let servicesAssembly: ServicesAssembly
    private var profileFactory: ProfileFactory?
    private var alertPresenter: AlertPresenter?
    private lazy var profileLinkButton = UIButton()
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
        
        profileFactory = ProfileFactory(delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        view.addSubview(profileAvatar)
        view.addSubview(profileName)
        view.addSubview(profileDescription)
        view.addSubview(myNftTableView)
        view.addSubview(profileEditButton)
        view.addSubview(profileLinkButton)
        configProfileAvatar()
        configProfileName()
        configProfileDescription()
        configMyNftTableView()
        configProfileEditButton()
        configLinkButton()
        fetchProfile()
    }
    
    @objc func profileEditButtonTapped() {
        guard let profile else { return }
        let viewController = ProfileEditViewController(profile: profile, delegate: self)
        present(viewController, animated: true)
    }
    
    @objc func profileLinkButtonTapped() {
        print("Link button tapped")
    }
    
    private func configProfileAvatar() {
        
        //Настройка отображения изображения профиля
        
        profileAvatar.layer.masksToBounds = true
        profileAvatar.clipsToBounds = true
        profileAvatar.layer.cornerRadius = 35
        profileAvatar.contentMode = .scaleAspectFill
        profileAvatar.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            profileAvatar.widthAnchor.constraint(equalToConstant: 70),
            profileAvatar.heightAnchor.constraint(equalToConstant: 70),
            profileAvatar.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            profileAvatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    //Настройка отображения имени профиля
    private func configProfileName() {
        profileName.textColor = UIColor(named: "YPBlack")
        profileName.font = UIFont.headline3
        profileName.text = "Timofey Bulokhov"
        
        profileName.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            profileName.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            profileName.leadingAnchor.constraint(equalTo: profileAvatar.trailingAnchor, constant: 16),
            profileName.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    //Настройка отображения описания профиля
    
    private func configProfileDescription() {
        
        profileDescription.backgroundColor = .clear
        profileDescription.isEditable = false
        profileDescription.isScrollEnabled = false
        profileDescription.sizeToFit()
        
        profileDescription.textContainer.lineFragmentPadding = 0
        profileDescription.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        profileDescription.textAlignment = .left
        profileDescription.textContainer.maximumNumberOfLines = 5
        
        let text = "Something looks like description ✅"
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing =  3
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          .foregroundColor: UIColor(named: "YPBlack"),
                          .font: UIFont.caption2
        ]
        
        profileDescription.attributedText = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
        
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            profileDescription.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: 20),
            profileDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    //Настройка отображения таблицы "Мои NFT" в профиле
    
    private func configMyNftTableView() {
        myNftTableView.backgroundColor = .clear
        myNftTableView.dataSource = self
        myNftTableView.delegate = self
        myNftTableView.register(myNftTableCell.self, forCellReuseIdentifier: myNftCellIdentifier)
        myNftTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
        
        myNftTableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            myNftTableView.topAnchor.constraint(equalTo: profileLinkButton.bottomAnchor, constant: 44),
            myNftTableView.bottomAnchor.constraint(equalTo: myNftTableView.topAnchor, constant: 162),
            myNftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    //Настройка отображения кнопки редактирования профиля
    
    private func configProfileEditButton() {
        
        profileEditButton.tintColor = UIColor(named: "YPBlack")
        profileEditButton.setImage(UIImage(named: "editButtonImage"), for: .normal)
        profileEditButton.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
        profileEditButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            profileEditButton.widthAnchor.constraint(equalToConstant: 42),
            profileEditButton.heightAnchor.constraint(equalToConstant: 42),
            profileEditButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            profileEditButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])
    }
    
    
    private func configLinkButton() {
        profileLinkButton.setTitleColor(UIColor(named: "YPBlue"), for: .normal)
        profileLinkButton.titleLabel?.font = UIFont.caption1
        profileLinkButton.contentHorizontalAlignment = .left
        
        profileLinkButton.addTarget(self, action: #selector(profileLinkButtonTapped), for: .touchUpInside)
        
        profileLinkButton.translatesAutoresizingMaskIntoConstraints = false
       
        
        NSLayoutConstraint.activate([
            profileLinkButton.heightAnchor.constraint(equalToConstant: 20),
            profileLinkButton.topAnchor.constraint(equalTo: profileDescription.bottomAnchor, constant: 8),
            profileLinkButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            profileLinkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func fetchProfile() {
        setFetchigInfoTiltesForViews()
        profileFactory?.loadProfile()
    }
    
    private func updateProfile(_ profile: Profile) {
        profileFactory?.updateProfileOnServer(profile)
    }
    
    private func updateControllerProfile(_ profile: Profile) {
        self.profile = profile
        nftIdArray = profile.nfts
        likedNFTIdArray = profile.likes
        
        profileName.text = profile.name
        profileDescription.text = profile.description
        profileLinkButton.setTitle(profile.website, for: .normal)
        
        updateUserPhotoWith(url: profile.avatar)
        
        myNftTableView.reloadData()
    }
    
    private func updateUserPhotoWith(url: String) {
        guard let avatarUrl = URL(string: url) else {
            return
        }
        profileAvatar.kf.setImage(with: avatarUrl)
    }
    
    private func setDefaultTitlesForViews() {
        profileName.text = "Имя не найдено"
        profileDescription.text = "Описание не найдено"
        profileLinkButton.setTitle("Ссылка не найдена", for: .normal)
    }
    
    private func setFetchigInfoTiltesForViews() {
        profileName.text = "Поиск имени"
        profileDescription.text = "Поиск описания"
        profileLinkButton.setTitle("Поиск ссылки сайта", for: .normal)
    }
    
    private func showServiceErrorAlert(_ error: ProfileServiceError, completion: @escaping () -> Void) {
        let errorString: String
        
        switch error {
            
        case .codeError(let value):
            errorString = value
        case .responseError(let value):
            errorString = "\(value)"
        case .invalidRequest:
            errorString = "Unknown error"
        }
        
        let message = "Не удалось обновить профиль"
        
        let model = AlertModel(
            title: "Ошибка: \(errorString)",
            message: message,
            closeAlertTitle: "Закрыть",
            completionTitle: "Повторить") {
                completion()
            }
        
        self.alertPresenter?.defaultAlert(model: model)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNftTableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: myNftCellIdentifier, for: indexPath) as? myNftTableCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.myNftCellLabel.text = myNftTableViewCells[indexPath.row] + " " + "(\(nftIdArray.count))"
        } else if indexPath.row == 1 {
            cell.myNftCellLabel.text = myNftTableViewCells[indexPath.row] + " " + "(\(likedNFTIdArray.count))"
        } else {
            cell.myNftCellLabel.text = myNftTableViewCells[indexPath.row]
        }
        
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileViewController: ProfileControllerDelegate {
    func didEndRedactingProfile(_ profile: Profile) {
        
        guard didProfileInfoChanged(profile) else { return }
        
        guard
            profile.name.count >= 2,
            profile.website.count >= 7
        else {
            let requirmentText = "Требования:"
            let nameRequirement =        "• Имя: 2-38 символов                  •"
            let websiteLinkRequirement = "• Cсылка сайта: 7-38 символов •"
            let messageRequirement = requirmentText + "\n" + nameRequirement + "\n" + websiteLinkRequirement
            
            let messageAdvice = "Если ссылка сайта не вмещается в заданый дипазон, можете сократить количетсво символов, сделав её гиперссылкой"
            
            let message = messageRequirement + "\n" + "\n" + messageAdvice
            
            let model = AlertModel(
                title: "Ошибка обновления профиля",
                message: message,
                closeAlertTitle: "Закрыть",
                completionTitle: "Вернутся") {
                    self.backToRedact(profile: profile)
                }
            
            alertPresenter?.defaultAlert(model: model)
            return
        }
        
        updateProfile(profile)
    }
    
    private func didProfileInfoChanged(_ profile: Profile) -> Bool {
        
        guard
            let oldProfile = self.profile,
            oldProfile.name == profile.name,
            oldProfile.website == profile.website,
            oldProfile.avatar == profile.avatar,
            oldProfile.description == profile.description
        else { return true }
        
        return false
    }
    
    private func backToRedact(profile: Profile) {
        let viewController = ProfileEditViewController(profile: profile, delegate: self)
        present(viewController, animated: true)
    }
}

extension ProfileViewController: ProfileFactoryDelegate {
    func didExecuteRequest(_ profile: Profile) {
        self.updateControllerProfile(profile)
    }
    
    func didFailToLoadProfile(with error: ProfileServiceError) {
        setDefaultTitlesForViews()
        showServiceErrorAlert(error) {
            self.fetchProfile()
        }
    }
    
    func didFailToUpdateProfile(with error: ProfileServiceError) {
        
        if let profile = UpdateProfileService.profileResult {
            
            showServiceErrorAlert(error) {
                self.updateProfile(profile)
            }
        } else if let profile = self.profile {
            
            let model = AlertModel(
                title: "Неизвестная ошбика",
                message: "Попробуйте отредактировать ещё раз",
                closeAlertTitle: "Отмена",
                completionTitle: "Вернуться") {
                    self.backToRedact(profile: profile)
                }
            
            alertPresenter?.defaultAlert(model: model)
        }
    }
}
