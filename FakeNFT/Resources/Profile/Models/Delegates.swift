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

protocol CollectionViewCellDelegate: AnyObject {
    func cellLikeButtonTapped(_ cell: MyNftCollectionViewCell)
}

protocol NFTCollectionControllerDelegate: AnyObject {
    func didUpdateFavoriteNFT(_ nftIdArray: [String])
}

protocol NFTFactoryDelegate: AnyObject {
    func didRecieveNFT(_ nft: NftModel)
    func didUpdateFavoriteNFT(_ favoriteNFTs: LikedNftModel)
    func didFailToLoadNFT(with error: ProfileServiceError)
    func didFailToUpdateFavoriteNFT(with error: ProfileServiceError)
}

protocol FetchNFTAlertDelegate {
    func tryToReloadNFT()
    func loadRestOfNFT()
    func closeActionTapped()
}
