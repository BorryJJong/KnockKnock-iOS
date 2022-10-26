//
//  ShopSearchPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchPresenterProtocol {
  var view: ShopSearchViewProtocol? { get set }

  func presentShopAddress(address: AddressResult)
  func presentCounty(county: [String])
  func presentCityList(cityList: [String])
}

final class ShopSearchPresenter: ShopSearchPresenterProtocol {
  weak var view: ShopSearchViewProtocol?

  func presentShopAddress(address: AddressResult) {
    self.view?.fetchShopAddress(address: address)
  }

  func presentCounty(county: [String]) {
    self.view?.fetchCountyList(county: county)
  }

  func presentCityList(cityList: [String]) {
    self.view?.fetchCityList(cityList: cityList)
  }
}
