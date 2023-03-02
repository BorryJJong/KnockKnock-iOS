//
//  ShopSearchInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import Foundation

protocol ShopSearchInteractorProtocol {
  var worker: ShopSearchWorkerProtocol? { get set }
  var presenter: ShopSearchPresenterProtocol? { get set }

  func fetchShopAddress(address: String?, isNew: Bool)
  func fetchCityList()
  func fetchCountyList(city: String)
}

final class ShopSearchInteractor: ShopSearchInteractorProtocol {

  var worker: ShopSearchWorkerProtocol?
  var presenter: ShopSearchPresenterProtocol?

  var selectedCity: String?
  var selectedCounty: String?

  private var page = 1

  /// - Parameters:
  ///  - address: 주소 data
  ///  - isNew: 새 검색어에 대한 검색결과 호출인 경우 true, 기존 검색 결과의 페이징을 위한 호출인 경우 false
  func fetchShopAddress(address: String?, isNew: Bool) {
    var keyword = ""

    guard let address = address else { return }

    if isNew {
      page = 1
    }

    if let city = selectedCity {
      if let county = selectedCounty {
        keyword = "\(city) \(county) \(address)"
      }
      keyword = "\(city) \(address)"
    } else {
      keyword = address
    }

    self.worker?.fetchShopAddress(
      keyword: keyword,
      page: page,
      completionHandler: { address in
        self.presenter?.presentShopAddress(address: address)
          self.page += 1
      }
    )
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
          if let county = $0[city] {
            self.presenter?.presentCounty(county: county)
          }
        }
      }
    )
  }
}

extension ShopSearchInteractor: DistrictSelectDelegate {
  func fetchSelectedCity(city: String) {
    self.selectedCity = city
    self.presenter?.presentSelectedCity(city: city)
  }

  func fetchSelectedCounty(county: String) {
    self.selectedCity = county
    self.presenter?.presentSelectedCounty(county: county)
  }
}
