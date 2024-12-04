//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 18.09.2024.
//

import UIKit

final class MyNftViewController: UIViewController {
    
    private weak var delegate: NFTCollectionControllerDelegate?
    private var nftFactory: NftFactory?
    private var alertPresenter: AlertPresenter?
    
    private lazy var myNftTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.isHidden = true
        label.text = "Мои NFT"
        label.font = UIFont.bodyBold
        return label
    }()
    
    private lazy var topViewsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YPWhite")
        return view
    }()
    
    private lazy var emptyNftLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.isHidden = true
        label.text = "У Вас ещё нет NFT"
        label.textAlignment = .center
        label.font = .bodyBold
        return label
    }()
    
    private lazy var nftSortingButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "sortButtonImage")
        button.tintColor = UIColor(named: "YPBlack")
        button.isHidden = true
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(nftSortingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nftCloseButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")
        button.tintColor = UIColor(named: "YPBlack")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(nftCloseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nftTableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .clear
        table.register(MyNftTableViewCell.self, forCellReuseIdentifier: nftTableViewCellIdentifier)
        return table
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlue")
        label.backgroundColor = UIColor(named: "YPBlack")?.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 16
        return label
    }()
    
    private let warningLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YPWhite")
        return view
    }()
    
    private let nftTableViewCellIdentifier = "nftTableCellIdentifier"
    
    private var nftResult: [NftModel] = []
    private var nftIdArray: [String]
    private var favoriteNFTsId: [String]
    private let params = GeomitricParams(cellCount: 1, leftInset: 16, rightInset: 16, cellSpacing: 0)
    private var warningLabelTopConstraint: [NSLayoutConstraint] = []
    
    // MARK: Init
    
    init(delegate: NFTCollectionControllerDelegate,
         nftIdArray: [String],
         favoriteNFTsId: [String]) {
        
        self.delegate = delegate
        self.nftIdArray = nftIdArray
        self.favoriteNFTsId = favoriteNFTsId
        super.init(nibName: nil, bundle: nil)
        alertPresenter = AlertPresenter(viewController: self)
        nftFactory = NftFactory(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        setupUI()
        
        if !nftIdArray.isEmpty {
            fetchNextNFT()
        }

        
    }
    
    @objc private func nftSortingButtonTapped() {
        alertPresenter?.sortionAlert(delegate: self)
    }
    
    @objc private func nftCloseButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: setupUI
    
    private func setupUI() {
        
        [topViewsContainer, myNftTitleLabel, emptyNftLabel, nftSortingButton, nftCloseButton, nftTableView, warningLabel, warningLabelContainer].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let constraint = warningLabel.topAnchor.constraint(equalTo: warningLabelContainer.topAnchor)
        warningLabelTopConstraint.append(constraint)
        warningLabelTopConstraint.first?.isActive = true
        
        NSLayoutConstraint.activate([
            topViewsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topViewsContainer.heightAnchor.constraint(equalToConstant: 42),
            topViewsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topViewsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            myNftTitleLabel.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            myNftTitleLabel.centerXAnchor.constraint(equalTo: topViewsContainer.centerXAnchor),
            
            emptyNftLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyNftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            emptyNftLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            
            nftSortingButton.widthAnchor.constraint(equalToConstant: 24),
            nftSortingButton.heightAnchor.constraint(equalToConstant: 24),
            nftSortingButton.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            nftSortingButton.trailingAnchor.constraint(equalTo: topViewsContainer.trailingAnchor, constant: -9),
            
            nftCloseButton.widthAnchor.constraint(equalToConstant: 24),
            nftCloseButton.heightAnchor.constraint(equalToConstant: 24),
            nftCloseButton.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            nftCloseButton.leadingAnchor.constraint(equalTo: topViewsContainer.leadingAnchor, constant: 9),
            
            nftTableView.topAnchor.constraint(equalTo: topViewsContainer.bottomAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            warningLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            warningLabelContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            warningLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            warningLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             
        ])
    }
    
    private func showWarningLabel(with text: String){
        warningLabel.text = text
        DispatchQueue.main.async {
            if let constraint = self.warningLabelTopConstraint.first {
                UIView.animate(withDuration: 0.5) {
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
    }

}

// MARK: Extensions

extension MyNftViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nftResult.isEmpty {
            emptyNftLabel.isHidden = false
        } else {
            emptyNftLabel.isHidden = true
            myNftTitleLabel.isHidden = false
            nftSortingButton.isHidden = false
        }
        return nftResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nftTableViewCellIdentifier, for: indexPath) as? MyNftTableViewCell else {
            return UITableViewCell()
        }
        if favoriteNFTsId.contains(nftResult[indexPath.section].id) {
            cell.setLikeImageForLikeButton()
        } else {
            cell.removeLikeImageForLikeButton()
        }
        cell.delegate = self
        cell.nft = nftResult[indexPath.section]
        cell.awakeFromNib()
        return cell
    }
}

extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MyNftViewController: NFTFactoryDelegate {
    
    func didUpdateFavoriteNFT(_ favoriteNFTs: LikedNftModel) {
        
        delegate?.didUpdateFavoriteNFT(favoriteNFTs.likes)

        if favoriteNFTs.likes.count > favoriteNFTsId.count {
            if let appendedNFT = favoriteNFTs.likes.first(where:{ !favoriteNFTsId.contains($0)}),
               let cellSection = nftResult.firstIndex(where: { $0.id == appendedNFT }) {
                favoriteNFTsId = favoriteNFTs.likes
                nftTableView.reloadData()
            }
        } else {
            if let removedNFT = favoriteNFTsId.first(where: { !favoriteNFTs.likes.contains($0) }),
               let cellSection = nftResult.firstIndex(where: { $0.id == removedNFT }) {
                favoriteNFTsId = favoriteNFTs.likes
                nftTableView.reloadData()
            }
        }
    }
    
    func didFailToUpdateFavoriteNFT(with error: ProfileServiceError) {
        let errorString: String
        switch error {
        case .codeError(let value):
            errorString = value
        case .responseError(let value):
            errorString = "\(value)"
        case .invalidRequest:
            errorString = "Unknown error"
        }
        let warningText = "Ошбика: \(errorString)" + "\n" + "Не удалось добавить в избранное"
        showWarningLabel(with: warningText)
    }
    
    func didRecieveNFT(_ nft: NftModel) {
        nftResult.append(nft)
        fetchNextNFT()
    }
    
    func didFailToLoadNFT(with error: ProfileServiceError) {
        UIBlockingProgressHUD.dismiss()
        nftTableView.reloadData()
        let errorString: String
        switch error {
        case .codeError(let value):
            errorString = value
        case .responseError(let value):
            errorString = "\(value)"
        case .invalidRequest:
            errorString = "Unknown error"
        }
        alertPresenter?.fetchNFTAlert(title: "Ошибка: \(errorString)", delegate: self)
    }
    
    private func fetchNextNFT() {
        UIBlockingProgressHUD.show()
        if nftResult.count < nftIdArray.count {
            let nextNFT = nftIdArray[nftResult.count]
            nftFactory?.loadNFT(id: nextNFT)
        } else {
            nftTableView.reloadData()
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func changeFavoriteNFTRequest(nftIdArray: [String]) {
        nftFactory?.updateFavoriteNFTOnServer(nftIdArray)
    }
}

extension MyNftViewController: FetchNFTAlertDelegate {
    func tryToReloadNFT() {
        fetchNextNFT()
    }
    
    func loadRestOfNFT() {
        let lostNFTIndex = nftResult.count == 0 ? 0 : nftResult.count - 1
        nftIdArray.remove(at: lostNFTIndex)
        fetchNextNFT()
    }
    
    func closeActionTapped() {
        emptyNftLabel.text = "Не удалось получить NFT"
    }
}

extension MyNftViewController: TableViewCellDelegate {
    
    func cellLikeButtonTapped(_ cell: UITableViewCell) {
        guard let indexPath = nftTableView.indexPath(for: cell) else {
            return
        }
        let likedNftId = nftResult[indexPath.section].id
        var newNFTArray: [String] = []
        if let nftId = favoriteNFTsId.first(where: { $0 == likedNftId }) {
            newNFTArray = favoriteNFTsId.filter({ $0 != nftId })
        } else {
            newNFTArray = favoriteNFTsId
            newNFTArray.append(likedNftId)
        }
        changeFavoriteNFTRequest(nftIdArray: newNFTArray)
    }
}

extension MyNftViewController: SortAlertDelegate {
    func sortByPrice() {
        nftResult.sort(by: { $0.price < $1.price })
        nftTableView.performBatchUpdates {
            var indesPaths: [IndexPath] = []
            for index in 0..<nftResult.count {
                indesPaths.append(IndexPath(item: 0, section: index))
            }
            nftTableView.reloadData()
        }
    }
    
    func sortByRate() {
        nftResult.sort(by: { $0.rating > $1.rating })
        nftTableView.performBatchUpdates {
            var indesPaths: [IndexPath] = []
            for index in 0..<nftResult.count {
                indesPaths.append(IndexPath(item: 0, section: index))
            }
            nftTableView.reloadData()
        }
    }
    
    func sortByName() {
        nftResult.sort(by: { $0.name < $1.name })
        nftTableView.performBatchUpdates {
            var indesPaths: [IndexPath] = []
            for index in 0..<nftResult.count {
                indesPaths.append(IndexPath(item: 0, section: index))
            }
            nftTableView.reloadData()
        }
    }
}


