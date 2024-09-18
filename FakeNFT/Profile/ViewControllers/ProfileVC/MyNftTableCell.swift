//
//  MyNftTableCell.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 10.09.2024.
//

import UIKit

final class MyNftTableCell: UITableViewCell {
    
    let myNftCellLabel = UILabel()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureMyNftCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: myNftTableCell
    
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
