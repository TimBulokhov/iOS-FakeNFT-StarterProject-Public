//
//  RequestNFT.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 02.10.2024.
//

import Foundation
struct RequestNFT: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var dto: Dto?
}
