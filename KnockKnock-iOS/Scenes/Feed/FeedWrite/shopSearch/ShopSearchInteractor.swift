//
//  ShopSearchInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchInteractorProtocol {
  var worker: ShopSearchWorkerProtocol? { get set }
  var presenter: ShopSearchPresenterProtocol? { get set }

  func fetchShopAddress(keyword: String)
  func fetchCityList()
  func fetchCountyList(city: String)
}

final class ShopSearchInteractor: ShopSearchInteractorProtocol {

  var worker: ShopSearchWorkerProtocol?
  var presenter: ShopSearchPresenterProtocol?

  func fetchShopAddress(keyword: String) {
    self.worker?.fetchShopAddress(
      keyword: keyword,
      completionHandler: { address in
        self.presenter?.presentShopAddress(address: address)
      })
  }

  func fetchCityList() {
    var cityArray: [String] = []

    self.worker?.fetchDistricts(
      completionHandler: { districtsData in
        districtsData.data.forEach {
          if let city = $0.keys.first {
            cityArray.append(city)
          }
        }
        self.presenter?.presentCityList(cityList: cityArray)
      }
    )
  }

  func fetchCountyList(city: String) {
    self.worker?.fetchDistricts(
      completionHandler: { districtsData in
        districtsData.data.forEach {
          if let data = $0[city] {
            self.presenter?.presentCounty(county: data)
          }
        }
      }
    )
  }
}

extension ShopSearchInteractor: DistrictSelectDelegate {
  func fetchSelectedCity(city: String) {
    self.presenter?.presentSelectedCity(city: city)
  }
}
