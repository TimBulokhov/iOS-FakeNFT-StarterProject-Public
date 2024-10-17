//
//  CoverViewController.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 17.09.2024.
//

import Foundation
import UIKit
import ProgressHUD
import Kingfisher

final class ChoosenNFTViewController: UIViewController, NFTFetchServiceDelegate {
    var coverURL: URL?
    var autor: String?
    var descriptionCollection: String?
    var titleCollection: String?
    var id: String?
    var currentInd: Int?
    var nftArray: [String]?
    var nftResult: CollectionNFTResult?
    var nftWithID: NFTListResult?
    private let token = RequestConstants.token
    private let nftService = NFTFetchService.shared
    private var nftListID = " "
    let coverImage: UIImageView = {
        let image = UIImageView()
        image .layer.cornerRadius = 16
        image .isHidden = false
        image .translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let autorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.numberOfLines = .max
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nftCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(CollectionNFTCell.self, forCellWithReuseIdentifier: CollectionNFTCell.reuseIdentifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nftCollection.contentInset = UIEdgeInsets.zero
        nftCollection.dataSource = self
        nftCollection.delegate = self
        setupNavigation()
        nftService.delegate = self
        setupUI()
    }
    
    func fetchNFTs(id: String) {
        ProgressHUD.show()
        nftService.fetchNFT(token, id: id) { [weak self] result in
            switch result {
            case .success(let nft):
                let nftResult = CollectionNFTResult(
                    createdAt: nft.createdAt,
                    name: nft.name,
                    cover: nft.cover,
                    nfts: nft.nfts,
                    description: nft.description,
                    author: nft.author,
                    id: nft.id)
                print("\(nftResult)")
                ProgressHUD.dismiss()
                self?.nftCollection.layoutIfNeeded()
                for nft in nftResult.nfts {
                    self?.fetchNftWhithIDCollection(id: nft)
                    self?.nftCollection.reloadData()
                }
            case .failure(let error):
                ProgressHUD.dismiss()
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchNftWhithIDCollection (id: String) {
        nftService.fetchNFTWithID(token, id: id) { result in
            DispatchQueue.main.async {
                ProgressHUD.show()
                switch result {
                case .success(let nftWithID):
                    self.nftWithID = nftWithID
                    self.nftCollection.reloadData()
                    ProgressHUD.dismiss()
                case .failure(let error):
                    print(error.localizedDescription)
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        [coverImage, titleLabel, autorLabel, descriptionLabel, nftCollection].forEach{
            view.addSubview($0)
        }
        coverImage.kf.setImage(with: coverURL)
        guard let descriptionCollection = descriptionCollection else {return}
        descriptionLabel.text = descriptionCollection
        guard let titleCollection = titleCollection else {return}
        titleLabel.text = titleCollection
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: view.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: 375),
            
            titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            autorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            autorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            autorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            autorLabel.heightAnchor.constraint(equalToConstant: 28),
            
            descriptionLabel.topAnchor.constraint(equalTo: autorLabel.bottomAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nftCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nftCollection.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        guard let autor = autor else {return}
        let fullText = "Автор коллекции: \(String(describing: autor))"
        let attributedString = NSMutableAttributedString(string: fullText)
        let prefixRange = (fullText as NSString).range(of: "Автор коллекции:")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: prefixRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: prefixRange)
        
        let nameRange = (fullText as NSString).range(of: autor)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: nameRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: nameRange)
        autorLabel.attributedText = attributedString
        let tapAutor = UITapGestureRecognizer(target: self, action: #selector(autorTapped(_:)))
        autorLabel.addGestureRecognizer(tapAutor)
    }
    
    func returnCollectionCell(for index: Int, completion: @escaping (CollectionCellModel?) -> Void) {
        if nftWithID == nil { return } else {
            guard let nftWithID = nftWithID else {
                completion(nil)
                return
            }
            
            guard index < nftWithID.images.count else {
                print("Invalid index or missing nftWithID")
                completion(nil)
                return
            }
            let cellModel = CollectionCellModel(
                image: nftWithID.images[index],
                name: nftWithID.name,
                rating: nftWithID.rating,
                price: nftWithID.price,
                id: nftWithID.id
            )
            completion(cellModel)
        }
    }
    
    func didFailToFetchNFTs(with error: Error) {
        print("Ошибка загрузки NFT: \(error.localizedDescription)")
    }
    
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func autorTapped(_ gesture:UITapGestureRecognizer) {
        let text = (autorLabel.text ?? "") as NSString
        let nameRange = text.range(of: autor ?? "")
        let location = gesture.location(in: autorLabel)
        let textStorage = NSTextStorage(attributedString: autorLabel.attributedText ?? NSAttributedString(string: ""))
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: autorLabel.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = autorLabel.numberOfLines
        textContainer.lineBreakMode = autorLabel.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if NSLocationInRange(index, nameRange) {
            if let url = URL(string: "https://practicum.yandex.ru") {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension ChoosenNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nftArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionNFTCell.reuseIdentifier, for: indexPath) as? CollectionNFTCell else {
            assertionFailure("Something went wrong with custom cell creation.")
            return UICollectionViewCell()
        }
        
        returnCollectionCell(for: indexPath.row) { cellModel in
            guard let model = cellModel else {
                print("Не удалось получить CollectionCellModel для индекса \(indexPath.row)")
                return
            }
            DispatchQueue.main.async {
                cell.setupCell(data: model)
            }
        }
        return cell
    }
}

extension ChoosenNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 9
        let topInset: CGFloat = (section == 0) ? 0 : 9
        return UIEdgeInsets(top: topInset, left: inset, bottom: 8, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}


