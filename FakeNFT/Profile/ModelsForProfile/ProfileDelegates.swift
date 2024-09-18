//
//  ProfileDelegates.swift
//  FakeNFT
//
//  Created by Timofey Bulokhov on 10.09.2024.
//

import UIKit

protocol ProfileFactoryDelegate: AnyObject {
    func didExecuteRequest(_ profile: Profile)
    func didFailToLoadProfile(with error: ProfileServiceError)
    func didFailToUpdateProfile(with error: ProfileServiceError)
}

protocol SortAlertDelegate: AnyObject {
    func sortByPrice()
    func sortByRate()
    func sortByName()
}

protocol ProfileControllerDelegate: AnyObject {
    func didEndRedactingProfile(_ profile: Profile)
}

protocol TextFieldAlertDelegate: UIViewController {
    func alertSaveTextButtonTappep(text: String?)
}
