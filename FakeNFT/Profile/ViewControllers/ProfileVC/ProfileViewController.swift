//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 10.09.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var profileAvatar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "avatarPlug")
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 35
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.font = UIFont.headline3
        label.text = "Timofey Bulokhov"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileDescription: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.isEditable = false
        text.isScrollEnabled = false
        text.sizeToFit()
        text.textContainer.lineFragmentPadding = 0
        text.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        text.textAlignment = .left
        text.textContainer.maximumNumberOfLines = 5
        
        let mockText = "Something looks like description ✅"
        let style = NSMutableParagraphStyle()
        style.lineSpacing =  3
        let attributes = [NSAttributedString.Key.paragraphStyle : style, .foregroundColor: UIColor(named: "YPBlack"), .font: UIFont.caption2
        ]
        
        text.attributedText = NSAttributedString(string: mockText, attributes: attributes as [NSAttributedString.Key : Any])
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var myNftTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self
        table.register(MyNftTableCell.self, forCellReuseIdentifier: myNftCellIdentifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var profileEditButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(named: "YPBlack")
        button.setImage(UIImage(named: "editButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var profileLinkButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "YPBlue"), for: .normal)
        button.titleLabel?.font = UIFont.caption1
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(profileLinkButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let myNftCellIdentifier = "tableCellIdentifier"
    private let myNftTableViewCells = ["Мои NFT", "Избранные NFT", "О разработчике"]
    private var nftIdArray: [String] = []
    private var favoriteNFTsId: [String] = []
    private var profile: Profile?
    private let servicesAssembly: ServicesAssembly
    private var profileFactory: ProfileFactory?
    private var alertPresenter: AlertPresenter?
    
    
    // MARK: Init
    
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
        setupUI()
        fetchProfile()
    }
    
    // MARK: Private
    
    @objc private func profileEditButtonTapped() {
        guard let profile else { return }
        let viewController = ProfileEditViewController(profile: profile, delegate: self)
        present(viewController, animated: true)
    }
    
    @objc private func profileLinkButtonTapped() {
        print("Link button tapped")
    }
    
    // MARK: SetupUI
    
    private func setupUI() {
        
        [profileAvatar, profileName, profileDescription, myNftTableView, profileEditButton, profileLinkButton].forEach{
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileAvatar.widthAnchor.constraint(equalToConstant: 70),
            profileAvatar.heightAnchor.constraint(equalToConstant: 70),
            profileAvatar.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            profileAvatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            profileName.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            profileName.leadingAnchor.constraint(equalTo: profileAvatar.trailingAnchor, constant: 16),
            profileName.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            profileDescription.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: 20),
            profileDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            myNftTableView.topAnchor.constraint(equalTo: profileLinkButton.bottomAnchor, constant: 44),
            myNftTableView.bottomAnchor.constraint(equalTo: myNftTableView.topAnchor, constant: 162),
            myNftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            profileEditButton.widthAnchor.constraint(equalToConstant: 42),
            profileEditButton.heightAnchor.constraint(equalToConstant: 42),
            profileEditButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            profileEditButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            
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
        favoriteNFTsId = profile.likes
        
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

// MARK: Extensions

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNftTableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: myNftCellIdentifier, for: indexPath) as? MyNftTableCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            cell.myNftCellLabel.text = myNftTableViewCells[indexPath.row] + " " + "(\(nftIdArray.count))"
        } else if indexPath.row == 1 {
            cell.myNftCellLabel.text = myNftTableViewCells[indexPath.row] + " " + "(\(favoriteNFTsId.count))"
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
        
        if indexPath.row == 0 {
            let viewController = MyNftViewController(delegate: self, nftIdArray: nftIdArray, favoriteNFTsId: favoriteNFTsId)
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
            
        } else if indexPath.row == 1 {
            let viewController = LikedNftViewController(delegate: self, favoriteNFTsId: favoriteNFTsId)
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
            
        } else if indexPath.row == 2,
                  let website = profile?.website,
                  let url = URL(string: website) {
            let viewController = WebViewController(webViewURL: url)
            present(viewController, animated: true)
        }
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
                completionTitle: "Вернуться") {
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

extension ProfileViewController: NFTCollectionControllerDelegate {
    func didUpdateFavoriteNFT(_ nftIdArray: [String]) {
        favoriteNFTsId = nftIdArray
        myNftTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
}
