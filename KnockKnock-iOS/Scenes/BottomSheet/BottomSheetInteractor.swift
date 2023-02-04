//
//  BottomSheetInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/23.
//

import Foundation

protocol BottomSheetInteractorProtocol {
  var router: BottomSheetRouterProtocol? { get set }
  var worker: BottomSheetWorkerProtocol? { get set }

  func sharePost()

  func passCityDataToShopSearch(city: String)
  func passCountyDataToShopSearch(county: String)

  func navigateToShopSearch()
  func dismissView(actionType: BottomSheetOption)
}

final class BottomSheetInteractor: BottomSheetInteractorProtocol {
  
  weak var districtSelectDelegate: DistrictSelectDelegate?

  var router: BottomSheetRouterProtocol?
  var worker: BottomSheetWorkerProtocol?

  var deleteAction: (() -> Void)?
  var editAction: (() -> Void)?
  var hideAction: (() -> Void)?

  var feedData: FeedShare?

  // MARK: - Buisiness Logic

  func sharePost() {
    LoadingIndicator.showLoading()

    self.worker?.sharePost(
      feedData: self.feedData,
      completionHandler: { isSuccess, error in

      if isSuccess {
        self.router?.dismissView(action: nil)
        
      } else {
        guard let error = error else { return }

        self.router?.presentErrorAlertView(message: error.message)
      }
    })
  }

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

    case .postHide:
      self.router?.dismissView(action: self.hideAction)

    case .postEdit:
      self.router?.dismissView(action: self.editAction)
      
    default:
      self.router?.dismissView(action: nil)
    }
  }
}
