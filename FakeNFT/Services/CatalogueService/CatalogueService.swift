//
//  CatalogueService.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 30.09.2024.
//

import Foundation

final class CatalogueService {
    private let token = RequestConstants.token
    private let baseURL = RequestConstants.baseURL
    
    static let shared = CatalogueService()
    
    private var task: URLSessionTask?
    
    private init() {}
    
    func fecthCatalogues(_ token: String, completion: @escaping (Result<[CollectionNFTResult],Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeRequestBody(token: token) else {
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
                        let result = try JSONDecoder().decode([CollectionNFTResult].self, from: data)
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
    
    func makeRequestBody(token: String) -> URLRequest? {
        let requestCatalogue = RequestCatalogue()
        
        guard let url = requestCatalogue.endpoint else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
}


