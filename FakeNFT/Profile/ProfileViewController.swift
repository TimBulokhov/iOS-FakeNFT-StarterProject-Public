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
    private let myNftTableViewCells = ["Мои NFT"]
    
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
        
        //Настройка отображения описания профиля
        
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
        view.addSubview(profileDescription)
        
        NSLayoutConstraint.activate([
            profileDescription.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: 20),
            profileDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        //Настройка отображения таблицы "Мои NFT" в профиле
        
        myNftTableView.backgroundColor = .clear
        myNftTableView.dataSource = self
        myNftTableView.delegate = self
        myNftTableView.register(myNftTableCell.self, forCellReuseIdentifier: myNftCellIdentifier)
        myNftTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
        
        myNftTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myNftTableView)
        
        NSLayoutConstraint.activate([
            myNftTableView.bottomAnchor.constraint(equalTo: myNftTableView.topAnchor, constant: 162),
            myNftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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
    //Заранее накидал логику подсчета элементов в ячейках
        
       /* if indexPath.row == 0 {
            cell.myNftCellLabel.text = myNftTableViewCells[indexPath.row] + " " + "(\(defaultNftIdArray.count))"
        } else if indexPath.row == 1 {
            cell.myNftCellLabel.text = myNftTableViewCells[indexPath.row] + " " + "(\(likedNftIdArray.count))"
        } else {
        } */
            cell.myNftCellLabel.text = myNftTableViewCells[indexPath.row]
        
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
