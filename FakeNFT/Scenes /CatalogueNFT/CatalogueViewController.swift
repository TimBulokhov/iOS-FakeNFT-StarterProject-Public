//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 09.09.2024.
//

import Foundation
import UIKit
import ProgressHUD
import Kingfisher


final class CatalogueViewController: UIViewController {
    private var catalogueNFT: [CollectionNFTResult] = []
    private let catalogueService = CatalogueService.shared
    private let choosenVC = ChoosenNFTViewController()
    let token = RequestConstants.token
    private let sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.isEnabled = true
        button.image = UIImage(named: "Sort")
        button.tintColor = .black
        return button
    }()
    
    private let catalogueTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        
        tableView.register(CatalogueTableViewCell.self, forCellReuseIdentifier: CatalogueTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createNavigation()
        catalogueTableView.dataSource = self
        catalogueTableView.delegate = self
        setupUI()
        sortButton.target = self
        sortButton.action = #selector(showSortWindow(_:))
        fetchNFTCollections()
    }
    
    private func fetchNFTCollections() {
        ProgressHUD.show()
        self.catalogueService.fecthCatalogues(token) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let catalog):
                self.catalogueNFT = catalog
                DispatchQueue.main.async {
                    self.catalogueTableView.reloadData()
                    self.catalogueTableView.layoutIfNeeded()
                    ProgressHUD.dismiss()
                }
            case .failure(let error):
                print(error.localizedDescription)
                ProgressHUD.dismiss()
            }
        }
    }
    
    private func createNavigation() {
        guard let navigationController = navigationController else {return}
        navigationItem.rightBarButtonItem = sortButton
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backIndicatorImage = UIImage()
        navigationController.navigationBar.backgroundColor = .white
    }
    
    private func setupUI() {
        catalogueTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(catalogueTableView)
        catalogueTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 47, right: 0)
        NSLayoutConstraint.activate([
            catalogueTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            catalogueTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            catalogueTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            catalogueTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func showSortWindow(_ sender: UIBarButtonItem) {
        let alert = AlertVC(title: "Сортировка", message: .none, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let sortByTitle = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.sortCatalogueByName()
        }
        
        let sortByCount = UIAlertAction(title: "По количеству NFT", style: .default) { [weak self] _ in
            self?.sortCatalogueByNFTCount()
        }
        alert.setCustomColor(UIColor.black.withAlphaComponent(0.5))
        alert.addAction(cancelAction)
        alert.addAction(sortByTitle)
        alert.addAction(sortByCount)
        present(alert, animated: true)
    }
    
    private func sortCatalogueByName() {
        catalogueNFT.sort { $0.name.lowercased() < $1.name.lowercased() }
        catalogueTableView.reloadData()
    }
    
    private func sortCatalogueByNFTCount() {
        catalogueNFT.sort { $0.nfts.count > $1.nfts.count }
        catalogueTableView.reloadData()
    }
    
    private func showChoosenNFT(whithURL url: URL, whithAutor autor: String, whithDescription description: String, whithTitle name: String, whithID id: String, whithNFTs nfts: [String]) {
        let choosenVC = ChoosenNFTViewController()
        choosenVC.coverURL = url
        choosenVC.autor = autor
        choosenVC.descriptionCollection = description
        choosenVC.titleCollection = name
        choosenVC.id = id
        choosenVC.nftArray = nfts
        choosenVC.fetchNFTs(id: id)
        choosenVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(choosenVC, animated: true)
    }
}

extension CatalogueViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogueTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CatalogueTableViewCell else {return UITableViewCell() }
        
        let nftCollection = catalogueNFT[indexPath.section]
        guard let encodedCover = nftCollection.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let imageURL = URL(string: encodedCover) else {
            print("Invalid image URL: \(nftCollection.cover)")
            return cell
        }
        let title = nftCollection.name
        let nftCount = nftCollection.nfts.count
        cell.configureCell(withTitle: title, nftCount: nftCount, imageURL: imageURL)
        cell.selectionStyle = .none
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        31
    }
}

extension CatalogueViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return catalogueNFT.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nftCollection = catalogueNFT[indexPath.section]
        guard let encodedCover = nftCollection.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let imageURL = URL(string: encodedCover) else {
            print("Invalid image URL: \(nftCollection.cover)")
            return }
        showChoosenNFT(whithURL: imageURL,
                       whithAutor: nftCollection.author,
                       whithDescription: nftCollection.description,
                       whithTitle: nftCollection.name,
                       whithID: nftCollection.id,
                       whithNFTs: nftCollection.nfts)
    }
}




