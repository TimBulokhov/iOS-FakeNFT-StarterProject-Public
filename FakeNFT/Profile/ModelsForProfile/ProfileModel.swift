//
//  ProfileModels.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 10.09.2024.
//

import Foundation

struct Profile: Codable {
    var name: String
    var avatar: String
    var description: String
    var website: String
    var nfts: [String]
    var likes: [String]
    var id: String
}
