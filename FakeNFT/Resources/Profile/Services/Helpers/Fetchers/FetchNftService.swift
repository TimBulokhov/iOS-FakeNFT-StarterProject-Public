//
//  FetchNftService.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 19.09.2024.
//

import Foundation

final class FetchNftService {
    
    private(set) var nftResult: NftModel?
    static let shared = FetchNftService()
    private var task: URLSessionTask?
    
    private init() {}
    
    func fecthNFT(_ token: String, NFTId: String, completion: @escaping (Result<NftModel, ProfileServiceError>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        guard let request = makeRequstBody(token: token, NFTId: NFTId) else {
            completion(.failure(ProfileServiceError.codeError("Uknown Error")))
            return
        }
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.task = nil
                if let error = error {
                    completion(.failure(ProfileServiceError.codeError("Unknown error")))
                    return
                }
                if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode  >= 300 {
                    completion(.failure(ProfileServiceError.responseError(response.statusCode)))
                    return
                }
                if let data = data {
                    do {
                        let nftResultInfo = try JSONDecoder().decode(NftModel.self, from: data)
                        self.nftResult = nftResultInfo
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
    
    func makeRequstBody(token: String, NFTId: String) -> URLRequest? {
        let NFTRequest = NFTRequest(id: NFTId)
        guard let url = NFTRequest.endpoint,
              var urlComponents = URLComponents(string: "\(url)")
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "nft_id", value: NFTId)
        ]
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(String(describing: token))", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        return request
    }
}
