//
//  NFT.swift
//  FakeNFT
//
//  Created by Мария Шагина on 16.09.2024.
//

import Foundation

import UIKit
 
struct NFTModel: Codable {
    let id: String
    let name: String
    let price: Float
    let rating: Int
    let images: [URL]
}
