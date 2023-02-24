//
//  ProfileRepositroy.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/26.
//

import Foundation

protocol ProfileRepositoryProtocol {
  func requestUserDeatil(completionHandler: @escaping (UserDetailDTO) -> Void)
  func requestEditProfile(
    nickname: String?,
    image: Data?,
    completionHandler: @escaping (Bool) -> Void
  )
  func checkDuplicateNickname(
    nickname: String,
    completionHandler: @escaping (Bool) -> Void
  )
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
    image: Data?,
    completionHandler: @escaping (Bool) -> Void
  ) {

    KKNetworkManager
      .shared
      .upload(
        object: ApiResponseDTO<Bool>.self,
        router: KKRouter.putUsers(
          nickname: nickname,
          image: image
        ),
        success: { response in
          completionHandler(response.code == 200)
        },
        failure: { error in
          print(error)
        }
      )
  }

  func checkDuplicateNickname(
    nickname: String,
    completionHandler: @escaping (Bool) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<Bool>.self,
        router: KKRouter.getDuplicateNickname(nickname: nickname),
        success: { response in
          guard let isSuccess = response.data else {
            // error
            return
          }
          completionHandler(isSuccess)
        },
        failure: { error in
          print(error)
        }
      )
  }
}
