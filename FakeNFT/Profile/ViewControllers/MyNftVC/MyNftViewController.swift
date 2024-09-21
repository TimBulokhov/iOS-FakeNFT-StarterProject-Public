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
    
    private lazy var myNftTitleLabel = UILabel()
    private lazy var topViewsContainer = UIView()
    private lazy var emptyNftLabel = UILabel()
    private lazy var nftSortingButton = UIButton()
    private lazy var nftCloseButton = UIButton()
    private lazy var nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let nftCollectionViewCellIdentifier = "nftCollectionCellIdentifier"
    
    private var nftResult: [NftModel] = []
    private var nftIdArray: [String]
    private var favoriteNFTsId: [String]
    private let params = GeomitricParams(cellCount: 1, leftInset: 16, rightInset: 16, cellSpacing: 0)
    private var warningLabelTopConstraint: [NSLayoutConstraint] = []
    private let warningLabel = UILabel()
    private let warningLabelContainer = UIView()
    
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
        configTopViewsContainer()
        configMyNftTitleLabel()
        configEmptyNftLabel()
        configNftSortingButton()
        configNftCollectionView()
        configNftCloseButton()
        configLimitWarningLabel()
        
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
    
    // MARK: topViewsContainer
    
    private func configTopViewsContainer() {
        topViewsContainer.backgroundColor = UIColor(named: "YPWhite")
        topViewsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topViewsContainer)
        
        NSLayoutConstraint.activate([
            topViewsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topViewsContainer.heightAnchor.constraint(equalToConstant: 42),
            topViewsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topViewsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    // MARK: myNftTitleLabel
    
    private func configMyNftTitleLabel(){
        myNftTitleLabel.textColor = UIColor(named: "YPBlack")
        myNftTitleLabel.isHidden = true
        myNftTitleLabel.text = "Мои NFT"
        myNftTitleLabel.font = UIFont.bodyBold
        
        myNftTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myNftTitleLabel)
        
        NSLayoutConstraint.activate([
            myNftTitleLabel.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            myNftTitleLabel.centerXAnchor.constraint(equalTo: topViewsContainer.centerXAnchor)
        ])
    }
    
    // MARK: emptyNftLabel
    
    private func configEmptyNftLabel(){
        emptyNftLabel.textColor = UIColor(named: "YPBlack")
        emptyNftLabel.isHidden = true
        
        emptyNftLabel.text = "У вас ещё нет NFT"
        emptyNftLabel.textAlignment = .center
        emptyNftLabel.font = .bodyBold
        emptyNftLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyNftLabel)
        
        NSLayoutConstraint.activate([
            emptyNftLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyNftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            emptyNftLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        ])
    }
    
    // MARK: nftSortingButton
    
    private func configNftSortingButton() {
        let image = UIImage(named: "sortButtonImage")
        nftSortingButton.tintColor = UIColor(named: "YPBlack")
        nftSortingButton.isHidden = true
        
        nftSortingButton.setImage(image, for: .normal)
        nftSortingButton.addTarget(self, action: #selector(nftSortingButtonTapped), for: .touchUpInside)
        
        nftSortingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nftSortingButton)
        
        NSLayoutConstraint.activate([
            nftSortingButton.widthAnchor.constraint(equalToConstant: 24),
            nftSortingButton.heightAnchor.constraint(equalToConstant: 24),
            nftSortingButton.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            nftSortingButton.trailingAnchor.constraint(equalTo: topViewsContainer.trailingAnchor, constant: -9)
        ])
    }
    
    // MARK: nftCollectionView
    
    private func configNftCollectionView() {
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
        nftCollectionView.backgroundColor = .clear
        
        nftCollectionView.register(MyNftCollectionViewCell.self, forCellWithReuseIdentifier: nftCollectionViewCellIdentifier)
        
        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nftCollectionView)
        
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: topViewsContainer.bottomAnchor),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: nftCloseButton
    
    private func configNftCloseButton() {
        let image = UIImage(systemName: "chevron.backward")
        nftCloseButton.tintColor = UIColor(named: "YPBlack")
        nftCloseButton.setImage(image, for: .normal)
        nftCloseButton.addTarget(self, action: #selector(nftCloseButtonTapped), for: .touchUpInside)
        nftCloseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nftCloseButton)
        
        NSLayoutConstraint.activate([
            nftCloseButton.widthAnchor.constraint(equalToConstant: 24),
            nftCloseButton.heightAnchor.constraint(equalToConstant: 24),
            nftCloseButton.centerYAnchor.constraint(equalTo: topViewsContainer.centerYAnchor),
            nftCloseButton.leadingAnchor.constraint(equalTo: topViewsContainer.leadingAnchor, constant: 9)
        ])
    }
    
    // MARK: warningLabel
    
    private func configLimitWarningLabel(){
        warningLabelContainer.backgroundColor = UIColor(named: "YPWhite")
        warningLabel.textColor = UIColor(named: "YPBlue")
        warningLabel.backgroundColor = UIColor(named: "YPBlack")?.withAlphaComponent(0.7)
        warningLabel.font = UIFont.systemFont(ofSize: 17)
        warningLabel.numberOfLines = 2
        warningLabel.textAlignment = .center
        warningLabel.layer.masksToBounds = true
        warningLabel.layer.cornerRadius = 16
        
        view.addSubview(warningLabel)
        view.addSubview(warningLabelContainer)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            warningLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            warningLabelContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            warningLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            warningLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        let constraint = warningLabel.topAnchor.constraint(equalTo: warningLabelContainer.topAnchor)
        warningLabelTopConstraint.append(constraint)
        warningLabelTopConstraint.first?.isActive = true
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

extension MyNftViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if nftResult.isEmpty {
            emptyNftLabel.isHidden = false
        } else {
            emptyNftLabel.isHidden = true
            myNftTitleLabel.isHidden = false
            nftSortingButton.isHidden = false
        }
        return nftResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nftCollectionViewCellIdentifier, for: indexPath) as? MyNftCollectionViewCell else {
            return UICollectionViewCell()
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

extension MyNftViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availibleSpacing = collectionView.frame.width - params.paddingWidth
        let cellWidth = availibleSpacing / params.cellCount
        return CGSize(width: cellWidth, height: cellWidth / 3.18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

extension MyNftViewController: NFTFactoryDelegate {
    
    func didUpdateFavoriteNFT(_ favoriteNFTs: LikedNftModel) {
        
        delegate?.didUpdateFavoriteNFT(favoriteNFTs.likes)

        if favoriteNFTs.likes.count > favoriteNFTsId.count {
            if let appendedNFT = favoriteNFTs.likes.first(where:{ !favoriteNFTsId.contains($0)}),
               let cellSection = nftResult.firstIndex(where: { $0.id == appendedNFT }) {
                favoriteNFTsId = favoriteNFTs.likes
                nftCollectionView.performBatchUpdates {
                    nftCollectionView.reloadSections([cellSection])
                }
            }
        } else {
            if let removedNFT = favoriteNFTsId.first(where: { !favoriteNFTs.likes.contains($0) }),
               let cellSection = nftResult.firstIndex(where: { $0.id == removedNFT }) {
                favoriteNFTsId = favoriteNFTs.likes
                nftCollectionView.performBatchUpdates {
                    nftCollectionView.reloadSections([cellSection])
                }
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
        nftCollectionView.reloadData()
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
            nftCollectionView.reloadData()
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

// добавление в избранное черновик
extension MyNftViewController: CollectionViewCellDelegate {
    func cellLikeButtonTapped(_ cell: MyNftCollectionViewCell) {
        guard let indexPath = nftCollectionView.indexPath(for: cell) else {
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
        nftCollectionView.performBatchUpdates {
            var indesPaths: [IndexPath] = []
            for index in 0..<nftResult.count {
                indesPaths.append(IndexPath(item: 0, section: index))
            }
            nftCollectionView.reloadItems(at: indesPaths)
        }
    }
    
    func sortByRate() {
        nftResult.sort(by: { $0.rating > $1.rating })
        nftCollectionView.performBatchUpdates {
            var indesPaths: [IndexPath] = []
            for index in 0..<nftResult.count {
                indesPaths.append(IndexPath(item: 0, section: index))
            }
            nftCollectionView.reloadItems(at: indesPaths)
        }
    }
    
    func sortByName() {
        nftResult.sort(by: { $0.name < $1.name })
        nftCollectionView.performBatchUpdates {
            var indesPaths: [IndexPath] = []
            for index in 0..<nftResult.count {
                indesPaths.append(IndexPath(item: 0, section: index))
            }
            nftCollectionView.reloadItems(at: indesPaths)
        }
    }
}


