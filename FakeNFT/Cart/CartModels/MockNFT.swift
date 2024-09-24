//
//  MockNFT.swift
//  FakeNFT
//
//  Created by Мария Шагина on 24.09.2024.
//

import UIKit

class MockNFT {
    static var nfts: [MockNFTModel] = [
        MockNFTModel(id: UUID(),
                     name: "April",
                     price: 1.78,
                     rating: 5,
                     image: UIImage(named: "april") ?? .add),
        MockNFTModel(id: UUID(),
                     name: "Greena",
                     price: 1.78,
                     rating: 2,
                     image: UIImage(named: "greena") ?? .add),
        MockNFTModel(id: UUID(),
                     name: "Spring",
                     price: 1.78,
                     rating: 4,
                     image: UIImage(named: "spring") ?? .add)
    ]
}
