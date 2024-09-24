//
//  AlertModel.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 16.09.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String?
    let closeAlertTitle: String
    let completionTitle: String
    let completion: () -> Void
}
