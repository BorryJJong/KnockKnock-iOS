//
//  ShopSearchRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import Foundation

protocol ShopSearchRepositoryProtocol {
  func requestShopAddress(
    keyword: String,
    page: Int,
    completionHandler: @escaping (AddressResult) -> Void
  )
}

final class ShopSearchRepository: ShopSearchRepositoryProtocol {
  func requestShopAddress(
    keyword: String,
    page: Int,
    completionHandler: @escaping (AddressResult) -> Void
  ) {
    KKNetworkManager.shared.request(
      object: AddressResult.self,
      router: KKRouter.requestShopAddress(query: keyword, page: page, size: 10),
      success: { response in
        completionHandler(response)
      },
      failure: { error in
        print(error)
      }
    )
  }
}
