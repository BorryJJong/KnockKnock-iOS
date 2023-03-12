//
//  VerifiedStoreRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/24.
//

import Foundation

protocol VerifiedStoreRepositoryProtocol {
  func requestVerifiedStoreDetailList() async -> ApiResponse<[StoreDetail]>?
  func requestVerifiedStoreList() async -> ApiResponse<[Store]>?
}

final class VerifiedStoreRepository: VerifiedStoreRepositoryProtocol {
  
  /// 인증 스토어 목록 조회
  func requestVerifiedStoreList() async -> ApiResponse<[Store]>? {
    do {

      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponse<[StoreDTO]>.self,
          router: .getHomeVerificationShop
        )

      guard let data = result.value else { return nil }

      return ApiResponse(
        code: data.code,
        message: data.message,
        data: data.data?.map{ $0.toDomain() }
      )

    } catch let error {

      print(error.localizedDescription)
      return nil
    }
  }

  func requestVerifiedStoreDetailList() async -> ApiResponse<[StoreDetail]>? {
    do {
      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponse<[StoreDetailDTO]>.self,
          router: .getVerificationShop
        )

      guard let data = result.value else { return nil }

      return ApiResponse(
        code: data.code,
        message: data.message,
        data: data.data?.map{ $0.toDomain() }
      )

    } catch let error {

      print(error.localizedDescription)
      return nil
    }
  }
}
