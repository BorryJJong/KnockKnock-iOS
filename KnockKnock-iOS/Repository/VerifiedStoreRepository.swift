//
//  VerifiedStoreRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/24.
//

import Foundation

protocol VerifiedStoreRepositoryProtocol {
  func requestVerifiedStoreList() async -> [Store]?
  func requestVerifiedStoreDetailList() async -> [StoreDetail]?
}

final class VerifiedStoreRepository: VerifiedStoreRepositoryProtocol {
  
  /// 인증 스토어 목록 조회
  func requestVerifiedStoreList() async -> [Store]? {
    do {
      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponseDTO<[StoreDTO]>.self,
          router: .getHomeVerificationShop
        )

      guard let data = result.data else { return nil }
      return data.map { $0.toDomain() }

    } catch let error {
      print(error)

      return nil
    }
  }

  func requestVerifiedStoreDetailList() async -> [StoreDetail]? {
    do {
      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponseDTO<[StoreDetailDTO]>.self,
          router: .getVerificationShop
        )

      guard let data = result.data else { return nil }
      return data.map { $0.toDomain() }

    } catch let error {
      print(error)

      return nil
    }
  }
}
