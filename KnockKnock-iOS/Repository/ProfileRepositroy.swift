//
//  ProfileRepositroy.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/26.
//

import Foundation

protocol ProfileRepositoryProtocol {
  func requestUserDeatil(completionHandler: @escaping (UserDetail) -> Void)
}

final class ProfileRepository: ProfileRepositoryProtocol {
  func requestUserDeatil(completionHandler: @escaping (UserDetail) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<UserDetail>.self,
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
}
