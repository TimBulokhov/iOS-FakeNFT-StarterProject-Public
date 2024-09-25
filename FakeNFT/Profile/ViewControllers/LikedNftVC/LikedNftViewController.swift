//
//  LikedNftViewController.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 25.09.2024.
//

import UIKit

final class LikedNftViewController: UIViewController {
    
    weak var delegate: NFTCollectionControllerDelegate?
    private var alertPresenter: AlertPresenter?
    private var nftFactory: NftFactory?
    
    private var warningLabelTopConstraint: [NSLayoutConstraint] = []
    private var nftResult: [NftModel] = []
    private var favoriteNFTsId: [String]
    
    private let likedNftCollectionCellIdentifier = "likedNftCollectionCellIdentifier"
    private let params = GeomitricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 7)
    
    private lazy var topViewsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YPWhite")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var likedNftTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.text = "Избранные NFT"
        label.font = UIFont.bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyLikedNftLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlack")
        label.text = "У Вас ещё нет избранных NFT"
        label.textAlignment = .center
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likedNftCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collection.register(LikedNftCollectionViewCell.self, forCellWithReuseIdentifier: likedNftCollectionCellIdentifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let likedNftWarningLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YPBlue")
        label.backgroundColor = UIColor(named: "YPBlack")?.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likedNftWarningLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YPWhite")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var likedNftCloseButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")
        button.tintColor = UIColor(named: "YPBlack")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeControllerButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    
    init(delegate: NFTCollectionControllerDelegate,
         favoriteNFTsId: [String]) {
        self.delegate = delegate
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
        if !favoriteNFTsId.isEmpty {
            fetchNextNFT()
        }
    }
    
    // MARK: Private
    
    @objc private func closeControllerButtonTapped() {
        dismiss(animated: true)
    }
    
    private func setupUI() {
        
        [topViewsContainer, likedNftTitleLabel, emptyLikedNftLabel, likedNftCollectionView, likedNftWarningLabelContainer, likedNftWarningLabel, likedNftCloseButton ].forEach{
            view.addSubview($0)
        }
        
        let constraint = likedNftWarningLabel.topAnchor.constraint(equalTo: likedNftWarningLabelContainer.topAnchor)
        warningLabelTopConstraint.append(constraint)
        warningLabelTopConstraint.first?.isActive = true
        
        NSLayoutConstraint.activate([
            topViewsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topViewsContainer.heightAnchor.constraint(equalToConstant: 42),
            topViewsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topViewsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            likedNftTitleLabel.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            likedNftTitleLabel.centerXAnchor.constraint(equalTo: topViewsContainer.centerXAnchor),
            
            emptyLikedNftLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyLikedNftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            emptyLikedNftLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLikedNftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            
            likedNftCollectionView.topAnchor.constraint(equalTo: topViewsContainer.bottomAnchor),
            likedNftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            likedNftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            likedNftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            likedNftWarningLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            likedNftWarningLabelContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            likedNftWarningLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            likedNftWarningLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            likedNftWarningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            likedNftWarningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            likedNftWarningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            likedNftCloseButton.widthAnchor.constraint(equalToConstant: 24),
            likedNftCloseButton.heightAnchor.constraint(equalToConstant: 24),
            likedNftCloseButton.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            likedNftCloseButton.leadingAnchor.constraint(equalTo: topViewsContainer.leadingAnchor, constant: 9)
            
        ])
    }
    
    private func showWarningLabel(with text: String){
        likedNftWarningLabel.text = text
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

extension LikedNftViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if nftResult.isEmpty {
            emptyLikedNftLabel.isHidden = false
            likedNftTitleLabel.isHidden = true
        } else {
            emptyLikedNftLabel.isHidden = true
            likedNftTitleLabel.isHidden = false
        }
        return nftResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: likedNftCollectionCellIdentifier, for: indexPath) as? LikedNftCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setLikeImageForLikeButton()
        cell.delegate = self
        cell.nft = nftResult[indexPath.row]
        cell.awakeFromNib()
        return cell
    }
}

extension LikedNftViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availibleSpacing = collectionView.frame.width - params.paddingWidth
        let cellWidth = availibleSpacing / params.cellCount
        return CGSize(width: cellWidth, height: cellWidth / 2.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension LikedNftViewController: NFTFactoryDelegate {
    
    func didUpdateFavoriteNFT(_ favoriteNFTs: LikedNftModel) {
        delegate?.didUpdateFavoriteNFT(favoriteNFTs.likes)
        if let removedNFT = favoriteNFTsId.first(where: { !favoriteNFTs.likes.contains($0) }),
           let cellRow = nftResult.firstIndex(where: { $0.id == removedNFT }) {
            favoriteNFTsId = favoriteNFTs.likes
            nftResult.remove(at: cellRow)
            likedNftCollectionView.performBatchUpdates {
                likedNftCollectionView.deleteItems(at: [IndexPath(item: cellRow, section: 0)])
            }
        } else {
            let warningText = "NFT удален из избранного" + "\n" + "Не удалось обновить экран"
            showWarningLabel(with: warningText)
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
        let warningText = "Ошбика: \(errorString)" + "\n" + "Не удалось удалить из избранных"
        showWarningLabel(with: warningText)
    }
    
    func didRecieveNFT(_ nft: NftModel) {
        nftResult.append(nft)
        fetchNextNFT()
    }
    
    func didFailToLoadNFT(with error: ProfileServiceError) {
        UIBlockingProgressHUD.dismiss()
        likedNftCollectionView.reloadData()
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
        if nftResult.count < favoriteNFTsId.count {
            let nextNFT = favoriteNFTsId[nftResult.count]
            nftFactory?.loadNFT(id: nextNFT)
        } else {
            likedNftCollectionView.reloadData()
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func changeFavoriteNFTRequest(nftIdArray: [String]) {
        nftFactory?.updateFavoriteNFTOnServer(nftIdArray)
    }
}

extension LikedNftViewController: FetchNFTAlertDelegate {
    
    func tryToReloadNFT() {
        fetchNextNFT()
    }
    
    func loadRestOfNFT() {
        let lostNFTIndex = nftResult.count == 0 ? 0 : nftResult.count - 1
        favoriteNFTsId.remove(at: lostNFTIndex)
        fetchNextNFT()
    }
    
    func closeActionTapped() {
        emptyLikedNftLabel.text = "Не удалось получить NFT"
    }
}

extension LikedNftViewController: CollectionViewCellDelegate {
    
    func cellLikeButtonTapped(_ cell: UICollectionViewCell) {
        guard let indexPath = likedNftCollectionView.indexPath(for: cell) else { return }
        let likedNftId = nftResult[indexPath.row].id
        var newNFTArray: [String] = []
        if let nftId = favoriteNFTsId.first(where: { $0 == likedNftId }) {
            newNFTArray = favoriteNFTsId.filter({ $0 != nftId })
        } else {
            let warningText = "Ошбика: Unknown error" + "\n" + "Не удалось удалить из избранных"
            showWarningLabel(with: warningText)
            return
        }
        changeFavoriteNFTRequest(nftIdArray: newNFTArray)
    }
}


