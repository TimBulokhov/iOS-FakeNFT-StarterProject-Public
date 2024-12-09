//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 16.09.2024.
//

import Foundation

struct ProfileRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
}
