//
//  UpdateNftService.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 19.09.2024.
//

import UIKit

final class UpdateNftService {
    
    private(set) static var nftResult: LikedNftModel?
    static let shared = UpdateNftService()
    private var task: URLSessionTask?
    
    private init() {}
    
    func updateFavoriteNFT(_ token: String, nftIdArray: [String], completion: @escaping (Result<LikedNftModel, ProfileServiceError>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        guard let request = makeRequestBody(nftIdArray: nftIdArray, token: token) else {
            completion(.failure(ProfileServiceError.codeError("Unknown Error")))
            return
        }
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.task = nil
                if error != nil {
                    completion(.failure(ProfileServiceError.codeError("Unknown error")))
                    return
                }
                if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode  >= 300 {
                    completion(.failure(ProfileServiceError.responseError(response.statusCode)))
                    return
                }
                if let data = data {
                    do {
                        let nftResultInfo = try JSONDecoder().decode(LikedNftModel.self, from: data)
                        UpdateNftService.nftResult = nftResultInfo
                        completion(.success(nftResultInfo))
                    } catch {
                        completion(.failure(ProfileServiceError.codeError("Unknown error")))
                    }
                }
            }
        }
        
        task = session
        session.resume()
    }
    
    
    private func makeRequestBody(nftIdArray: [String], token: String) -> URLRequest? {
        
        let profileRequest = ProfileRequest(id: "1")
        
        guard let url = profileRequest.endpoint,
              var urlComponents = URLComponents(string: "\(url)")
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var encodedLikes = nftIdArray.joined(separator: ",")
        
        if encodedLikes.isEmpty {
            encodedLikes = "null"
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "likes", value: encodedLikes)
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("\(String(describing: token))", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
}

