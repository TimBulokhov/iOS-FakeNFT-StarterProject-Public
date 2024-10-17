//
//  NFTService.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 02.10.2024.
//

import Foundation

protocol NFTFetchServiceDelegate: AnyObject {
    func didFailToFetchNFTs(with error: Error)
}

final class NFTFetchService {
    weak var delegate: NFTFetchServiceDelegate?
    private let token = RequestConstants.token
    private let baseURL = RequestConstants.baseURL
    static let shared = NFTFetchService()
    private var task: URLSessionTask?
    private let decoder = JSONDecoder()
    private var isRequestInProgress = false
    
    private init() {}
    
    func fetchNFT(_ token: String, id: String, completion: @escaping (Result<CollectionNFTResult,Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeRequest(token: token, id: id) else {
            completion(.failure(NetworkClientError.urlSessionError))
            return
        }
        
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.task = nil
                if let error = error {
                    completion(.failure(NetworkClientError.urlSessionError))
                    return
                }
                if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode  >= 300 {
                    completion(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                    print("\(response.statusCode)")
                    return
                }
                if let data = data {
                    do {
                        let result = try decoder.decode(CollectionNFTResult.self, from: data)
                        completion(.success(result))
                    } catch {
                        self.delegate?.didFailToFetchNFTs(with: error)
                        completion(.failure(NetworkClientError.parsingError))
                    }
                }
            }
        }
        task = session
        session.resume()
    }
    
    func fetchNFTWithID(_ token: String, id: String, completion: @escaping (Result<NFTListResult,Error>) -> Void) {
        assert(Thread.isMainThread)
        if isRequestInProgress {
            return
        }
        isRequestInProgress = true
        
        guard let request = makeRequestBodywhithID(token: token, id: id) else {
            completion(.failure(NetworkClientError.urlSessionError))
            isRequestInProgress = false
            return
        }
        
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                isRequestInProgress = false
                if let error = error {
                    print("\(error)")
                    completion(.failure(NetworkClientError.urlSessionError))
                  
                    return
                }
                if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode  >= 300 {
                    completion(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                    print("\(response.statusCode)")
                    return
                }
                if let data = data {
                    do {
                        let result = try decoder.decode(NFTListResult.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(NetworkClientError.parsingError))
                    }
                }
            }
        }
        task = session
        session.resume()
    }
    
    private func makeRequestBodywhithID(token: String, id: String) -> URLRequest? {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(id)") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    private func makeRequest(token: String, id: String) -> URLRequest? {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)") else {
            assertionFailure("Failed to create URL")
            return nil
        }
               
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
}


