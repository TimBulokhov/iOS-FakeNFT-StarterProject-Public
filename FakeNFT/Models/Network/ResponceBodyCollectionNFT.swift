//
//  CollectionNFT.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 30.09.2024.
//

import Foundation

// Получение списка коллекций  /api/v1/collections

struct CollectionNFTResult: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

//Получение списка NFT

public struct NFTListResult: Codable {
    var createdAt: String
    var name: String
    var images: [URL] //массив ссылок
    var rating: Int
    var description: String
    var price: Float
    var author: String
    var id: String
}

struct CollectionCellModel {
    let image: URL
    let name: String
    let rating: Int
    let price: Float
    let id: String
}


