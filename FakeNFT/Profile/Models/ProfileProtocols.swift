//
//  ProfileProtocols.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 16.09.2024.
//

import Foundation

enum ProfileServiceError: Error {
    case codeError(_ value: String)
    case responseError(_ value: Int)
    case invalidRequest
}
