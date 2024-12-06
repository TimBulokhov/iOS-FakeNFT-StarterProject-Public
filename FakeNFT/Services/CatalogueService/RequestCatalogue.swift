//
//  RequestCatalogue.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 01.10.2024.
//

import Foundation

struct RequestCatalogue: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var dto: Dto?
}


