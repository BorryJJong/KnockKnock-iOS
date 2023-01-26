//
//  ProfileRepositroy.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/26.
//

import UIKit

protocol ProfileRepositoryProtocol {
  func requestUserDeatil(completionHandler: @escaping (UserDetailDTO) -> Void)
  func requestEditProfile(nickname: String?, image: UIImage?, completionHandler: @escaping (Bool) -> Void)
}

final class ProfileRepository: ProfileRepositoryProtocol {

  func requestUserDeatil(completionHandler: @escaping (UserDetailDTO) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<UserDetailDTO>.self,
        router: KKRouter.getUsersDetail,
        success: { response in
          guard let data = response.data else {
            // error
            return
          }
          completionHandler(data)
        },
        failure: { error in
          print(error)

        }
      )
  }

  func requestEditProfile(
    nickname: String?,
    image: UIImage?,
    completionHandler: @escaping (Bool) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<Bool>.self,
        router: KKRouter.putUsers(nickname: nickname, image: image),
        success: { response in
          completionHandler(response.code == 200)
        },
        failure: { error in
          print(error)
        }
      )
  }
}
