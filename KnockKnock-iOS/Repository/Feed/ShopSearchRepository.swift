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
    completionHandler: @escaping (AddressResponse?) -> Void
  )

  func fetchDistricts() -> DistrictsData?
}

final class ShopSearchRepository: ShopSearchRepositoryProtocol {
  func requestShopAddress(
    keyword: String,
    page: Int,
    completionHandler: @escaping (AddressResponse?) -> Void
  ) {
    KKNetworkManager.shared.request(
      object: AddressResponse.self,
      router: KKRouter.requestShopAddress(
        query: keyword,
        page: page,
        size: 15
      ),
      success: { response in
        completionHandler(response)
      },
      failure: { response, error in
        completionHandler(nil)
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
