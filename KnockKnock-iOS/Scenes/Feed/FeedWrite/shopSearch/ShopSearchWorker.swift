//
//  ShopSearchWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchWorkerProtocol {
  func fetchShopAddress(
    keyword: String,
    page: Int,
    completionHandler: @escaping (AddressResult) -> Void
  )
}

final class ShopSearchWorker: ShopSearchWorkerProtocol {

  private let repository: ShopSearchRepositoryProtocol

  init(repository: ShopSearchRepository) {
    self.repository = repository
  }

  func fetchShopAddress(
    keyword: String,
    page: Int,
    completionHandler: @escaping (AddressResult) -> Void
  ) {
    repository.requestShopAddress(
      keyword: keyword,
      page: page,
      completionHandler: { result in
        completionHandler(result)
      })
  }
}
