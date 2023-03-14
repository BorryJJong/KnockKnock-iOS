//
//  ProfileRepositroy.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/26.
//

import Foundation

protocol ProfileRepositoryProtocol {
  func requestUserDetail() async -> ApiResponse<UserDetail>?

  func requestEditProfile(
    nickname: String?,
    image: Data?,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func checkDuplicateNickname(
    nickname: String,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
}

final class ProfileRepository: ProfileRepositoryProtocol {

  typealias OncompletionHandler = (ApiResponse<Bool>?) -> Void

  func requestUserDetail() async -> ApiResponse<UserDetail>? {
    do {
      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponse<UserDetailDTO>.self,
          router: .getUsersDetail
        )

      guard let response = result.value else { return nil }

      return ApiResponse(
        code: response.code,
        message: response.message,
        data: await response.data?.toDomain()
      )

    } catch {

      print(error.localizedDescription)
      return nil
    }
  }

  func requestEditProfile(
    nickname: String?,
    image: Data?,
    completionHandler: @escaping OncompletionHandler
  ) {

    KKNetworkManager
      .shared
      .upload(
        object: ApiResponse<Bool>.self,
        router: KKRouter.putUsers(
          nickname: nickname,
          image: image
        ),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }

  func checkDuplicateNickname(
    nickname: String,
    completionHandler: @escaping OncompletionHandler
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Bool>.self,
        router: KKRouter.getDuplicateNickname(nickname: nickname),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }
}
