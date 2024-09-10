//
//  myNftTableCell.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 10.09.2024.
//

import UIKit

final class myNftTableCell: UITableViewCell {
    
    let myNftCellLabel = UILabel()
    
    //Настройка отображения ячейки в таблице "Мои NFT"
    
    private func configureMyNftCell(){
        
        myNftCellLabel.font = UIFont.bodyBold
        myNftCellLabel.numberOfLines = 2
        myNftCellLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(myNftCellLabel)
        
        NSLayoutConstraint.activate([
            myNftCellLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            myNftCellLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            myNftCellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            myNftCellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56)
        ])
    }
}
