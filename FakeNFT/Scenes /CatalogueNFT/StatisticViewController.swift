//
//  StatisticViewController.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 09.09.2024.
//

import Foundation
import UIKit
final class StatisticViewController: UIViewController {
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
