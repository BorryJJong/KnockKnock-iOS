//
//  BottomSheetInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/23.
//

import Foundation

protocol BottomSheetInteractorProtocol {
  var router: BottomSheetRouterProtocol? { get set }

  func passCityDataToShopSearch(city: String)
  func passCountyDataToShopSearch(county: String)

  func navigateToShopSearch()
  func dismissView(actionType: BottomSheetOption)
}

final class BottomSheetInteractor: BottomSheetInteractorProtocol {
  
  weak var districtSelectDelegate: DistrictSelectDelegate?
  var router: BottomSheetRouterProtocol?

  var deleteAction: (() -> Void)?
  var editAction: (() -> Void)?

  var feedData: FeedList.Post?

  // MARK: - Routing

  func passCityDataToShopSearch(city: String) {
    self.districtSelectDelegate?.fetchSelectedCity(city: city)
    self.navigateToShopSearch()
  }

  func passCountyDataToShopSearch(county: String) {
    self.districtSelectDelegate?.fetchSelectedCounty(county: county)
    self.navigateToShopSearch()
  }

  func navigateToShopSearch() {
    self.router?.navigateToShopSearch()
  }

  func dismissView(actionType: BottomSheetOption) {
    switch actionType {
    case .postDelete:
      self.router?.dismissView(action: self.deleteAction)

    default:
      self.router?.dismissView(action: nil)
    }
  }
}
