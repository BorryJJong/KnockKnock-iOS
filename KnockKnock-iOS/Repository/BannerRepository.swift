//
//  BannerRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/24.
//

import Foundation

protocol BannerRepositoryProtocol {
  func requestBanner(bannerType: BannerType) async -> [HomeBanner]?
}

final class BannerRepository: BannerRepositoryProtocol {

  /// 홈 메인/바 배너 조회
  ///
  /// - Parameters:
  ///  - bannerType: 배너 형태(메인/바)
  func requestBanner(bannerType: BannerType) async -> [HomeBanner]? {
    do {

      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponseDTO<[HomeBannerDTO]>.self,
          router: .getBanner(bannerType: bannerType.rawValue)
        )

      guard let data = result.data else { return nil }
      return data.map { $0.toDomain() }

    } catch {
      print(error)

      return nil
    }
  }
}
