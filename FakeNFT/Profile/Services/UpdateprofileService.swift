//
//  UpdateprofileService.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 16.09.2024.
//

import UIKit

final class UpdateProfileService {
    
    private(set) static var profileResult: Profile?
    static let shared = UpdateProfileService()
    
    private var task: URLSessionTask?
    
    private init() {}
    
    func updateProfile(_ token: String,
                       profile: Profile,
                       completion: @escaping (Result<Profile,ProfileServiceError>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        UpdateProfileService.profileResult = profile
        
        guard let request = makeRequestBody(profile: profile, token: token) else {
            completion(.failure(ProfileServiceError.codeError("Uknown Error")))
            return
        }
        
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
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
                        let profileResultInfo = try JSONDecoder().decode(Profile.self, from: data)
                        UpdateProfileService.profileResult = profileResultInfo
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
    
    private func makeRequestBody(profile: Profile, token: String) -> URLRequest? {
        let profileRequest = ProfileRequest(id: "1")
        
        guard let url = profileRequest.endpoint else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var urlComponents = URLComponents(string: "\(url)")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "name", value: "\(profile.name)"),
            URLQueryItem(name: "avatar", value: "\(profile.avatar)"),
            URLQueryItem(name: "description", value: "\(profile.description)"),
            URLQueryItem(name: "website", value: "\(profile.website)")
        ]
        
        guard let url = urlComponents?.url else {
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
