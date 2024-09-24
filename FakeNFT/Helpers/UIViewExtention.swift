//
//  UIViewExtention.swift
//  FakeNFT
//
//  Created by Мария Шагина on 24.09.2024.
//

import UIKit

extension UIView {
    func setupView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
