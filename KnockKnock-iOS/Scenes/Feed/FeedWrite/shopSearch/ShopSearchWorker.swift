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
    completionHandler: @escaping (AddressResponse) -> Void
  )
  func fetchDistricts(completionHandler: @escaping (DistrictsData) -> Void)
}

final class ShopSearchWorker: ShopSearchWorkerProtocol {

  private let repository: ShopSearchRepositoryProtocol

  init(repository: ShopSearchRepository) {
    self.repository = repository
  }

  func fetchShopAddress(
    keyword: String,
    page: Int,
    completionHandler: @escaping (AddressResponse) -> Void
  ) {
    self.repository.requestShopAddress(
      keyword: keyword,
      page: page,
      completionHandler: { result in
        completionHandler(result)
      }
    )
  }

  func fetchDistricts(
    completionHandler: @escaping (DistrictsData) -> Void
  ) {
    if let districtsData = self.repository.fetchDistricts() {
      completionHandler(districtsData)
    }
  }
}
