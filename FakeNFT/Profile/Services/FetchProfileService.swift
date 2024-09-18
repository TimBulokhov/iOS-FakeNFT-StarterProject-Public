//
//  FetchProfileService.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 16.09.2024.
//

import UIKit

final class FetchProfileService {
    
    private(set) var profileResult: Profile?
    static let shared = FetchProfileService()
    
    private var task: URLSessionTask?
    
    private init() {}
    
    func fecthProfile(_ token: String, completion: @escaping (Result<Profile,ProfileServiceError>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeRequstBody(token: token) else {
            completion(.failure(ProfileServiceError.codeError("Uknown Error")))
            return
        }
        
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
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
                        let profileResultInfo = try JSONDecoder().decode(Profile.self, from: data)
                        self.profileResult = profileResultInfo
                        completion(.success(profileResultInfo))
                    } catch {
                        completion(.failure(ProfileServiceError.codeError("Unknown error")))
                    }
                }
                self.task = nil
            }
        }
        task = session
        session.resume()
    }
    
    func makeRequstBody(token: String) -> URLRequest? {
        let profileRequest = ProfileRequest(id: "1")
        
        guard let url = profileRequest.endpoint else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(String(describing: token))", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
}

