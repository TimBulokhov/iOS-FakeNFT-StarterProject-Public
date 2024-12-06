//
//  NftModel.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 19.09.2024.
//

import Foundation

struct NftModel: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
