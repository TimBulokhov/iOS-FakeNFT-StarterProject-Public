//
//  ProfileFactory.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 16.09.2024.
//

import Foundation

final class ProfileFactory {
    
    private weak var delegate: ProfileFactoryDelegate?
    private let fetchProfileService = FetchProfileService.shared
    private let updateProfileService = UpdateProfileService.shared
    
    init(delegate: ProfileFactoryDelegate) {
        self.delegate = delegate
    }
    
    func loadProfile() {
        if let profile = fetchProfileService.profileResult {
            delegate?.didExecuteRequest(profile)
            return
        }
        let token = Token.token
        
        UIBlockingProgressHUD.show()
        
        fetchProfileService.fecthProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.delegate?.didExecuteRequest(profile)
            case .failure(let error):
                self.delegate?.didFailToLoadProfile(with: error)
            }
            
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func updateProfileOnServer(_ profile: Profile) {
        let token = Token.token
        
        UIBlockingProgressHUD.show()
        
        updateProfileService.updateProfile(token, profile: profile) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.delegate?.didExecuteRequest(profile)
            case .failure(let error):
                self.delegate?.didFailToUpdateProfile(with: error)
            }
            
            UIBlockingProgressHUD.dismiss()
        }
    }
}

