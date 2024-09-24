//
//  CartRouter.swift
//  FakeNFT
//
//  Created by Мария Шагина on 24.09.2024.
//

import UIKit

enum CartSegue {
    case pay
    case choicePayment
    case purchaseResult
}

protocol CartRouter {
    func perform(_ segue: CartSegue, from source: CartVC)
}

final class DefaultCartRouter: CartRouter {
    
    private var viewModel: CartViewModelProtocol
    
    init(viewModel: CartViewModelProtocol = CartViewModel()) {
        self.viewModel = viewModel
    }
    
    func perform(_ segue: CartSegue, from source: CartVC) {
        switch segue {
        case .pay:
            let vc = DefaultCartRouter.makePaymentViewController()
            source.navigationController?.present(vc, animated: true)
        case .choicePayment:
            let vc = DefaultCartRouter.makePaymentViewController()
            source.navigationController?.present(vc, animated: true)
        case .purchaseResult:
            let vc = DefaultCartRouter.makePaymentViewController()
            source.navigationController?.present(vc, animated: true)
        }
    }
    
    static func makeCartViewController() -> UINavigationController {
        let vc = CartVC()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
    
    static func makePaymentViewController() -> UIViewController {
        let vc = PaymentChoiceVC()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func makePurchaseViewController() -> UIViewController {
        let vc = PurchaseResultVC()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
