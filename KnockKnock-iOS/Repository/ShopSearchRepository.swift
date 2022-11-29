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

  func fetchDistricts() -> DistrictsData?
}

final class ShopSearchRepository: ShopSearchRepositoryProtocol {
  func requestShopAddress(
    keyword: String,
    page: Int,
    completionHandler: @escaping (AddressResult) -> Void
  ) {
    KKNetworkManager.shared.request(
      object: AddressResult.self,
      router: KKRouter.requestShopAddress(query: keyword, page: page, size: 15),
      success: { response in
        completionHandler(response)
      },
      failure: { error in
        print(error)
      }
    )
  }

  func fetchDistricts() -> DistrictsData? {
    do {
      if let path = Bundle.main.path(forResource: "districts", ofType: "json") {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let jsonData = try JSONDecoder().decode(DistrictsData.self, from: data)
        return jsonData
      }
    } catch {
      print(error)
    }
    return nil
  }
}
