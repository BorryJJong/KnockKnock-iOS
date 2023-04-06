//
//  ShopSearchPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import Foundation

protocol ShopSearchPresenterProtocol {
  var view: ShopSearchViewProtocol? { get set }

  func presentShopAddress(address: AddressResponse)
  func presentCounty(county: [String])
  func presentCityList(cityList: [String])

  func presentSelectedCity(city: String)
  func presentSelectedCounty(county: String)

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class ShopSearchPresenter: ShopSearchPresenterProtocol {
  weak var view: ShopSearchViewProtocol?

  func presentShopAddress(address: AddressResponse) {
    self.view?.fetchShopAddress(address: address)
  }

  func presentCounty(county: [String]) {
    self.view?.fetchCountyList(county: county)
  }

  func presentCityList(cityList: [String]) {
    self.view?.fetchCityList(cityList: cityList)
  }

  func presentSelectedCity(city: String) {
    self.view?.fetchSelectedCity(city: city)
  }

  func presentSelectedCounty(county: String) {
    self.view?.fetchSelectedCounty(county: county)
  }

  func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    self.view?.showAlertView(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
