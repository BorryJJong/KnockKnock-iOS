//
//  BannerRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/24.
//

import Foundation

protocol BannerRepositoryProtocol {
  func requestBanner(bannerType: BannerType) async -> ApiResponse<[HomeBanner]>?
}

final class BannerRepository: BannerRepositoryProtocol {

  /// 홈 메인/바 배너 조회
  ///
  /// - Parameters:
  ///  - bannerType: 배너 형태(메인/바)
  func requestBanner(bannerType: BannerType) async -> ApiResponse<[HomeBanner]>? {

    do {
      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponse<[HomeBannerDTO]>.self,
          router: .getBanner(bannerType: bannerType.rawValue)
        )

      guard let data = result.value else { return nil }
      
      return ApiResponse(
        code: data.code,
        message: data.message,
        data: data.data?.map{ $0.toDomain() }
      )

    } catch {

      print(error.localizedDescription)
      return nil
    }
  }
}
