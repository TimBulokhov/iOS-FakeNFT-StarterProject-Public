//
//  CartVC.swift
//  FakeNFT
//
//  Created by Мария Шагина on 15.09.2024.
//

import UIKit

final class CartVC: UIViewController {
//    MARK: - properties
    var cartItems: [NFT] = [NFT(image: UIImage(named: "april")!, name: "April", rating: UIImage(named: "1stars")!, price: "1,78"),
                            NFT(image: UIImage(named: "greena")!, name: "Greena", rating: UIImage(named: "3stars")!, price: "1,78"),
                            NFT(image: UIImage(named: "spring")!, name: "Spring", rating: UIImage(named: "5stars")!, price: "1,78")]
    
    private let tableView = UITableView()
    private let navigationBar = UINavigationBar()
    
//    MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: "NFTCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
        let navItem = UINavigationItem(title: "")
        let rightButton = UIBarButtonItem(image: UIImage(named: "MenuPays"), style: .plain, target: self, action: #selector(Self.didTapMenuButton))
        rightButton.tintColor = .black
        navigationBar.barTintColor = .systemBackground
        navigationBar.isTranslucent = false
        navItem.rightBarButtonItem = rightButton
        navigationBar.setItems([navItem], animated: false)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
//    MARK: - actions
    //   TO DO:
    @objc
    private func didTapMenuButton() {}
    
}

//    MARK: - UITableViewDataSource, UITableViewDelegate
extension CartVC: UITableViewDataSource, UITableViewDelegate {
    
    //     MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let
        cell = tableView.dequeueReusableCell(withIdentifier: "NFTCell", for: indexPath) as! NFTTableViewCell
        let item = cartItems[indexPath.row]
        cell.configure(with: item)
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt
                   indexPath: IndexPath) {
        if editingStyle == .delete {
            cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at:
                                    [indexPath], with: .fade)
        }
    }
}
