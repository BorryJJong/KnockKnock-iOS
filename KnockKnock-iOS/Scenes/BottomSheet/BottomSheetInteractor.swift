//
//  BottomSheetInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/23.
//

import Foundation

final class BottomSheetInteractor: BottomSheetInteractorProtocol {
  
  weak var districtSelectDelegate: DistrictSelectDelegate?
  weak var challengeSortDelegate: ChallengeSortDelegate?

  var router: BottomSheetRouterProtocol?
  var worker: BottomSheetWorkerProtocol?
  var presenter: BottomSheetPresenterProtocol?

  var options: [BottomSheetOption]?
  var districtsType: DistrictsType?
  var districtContent: [String]?
  var bottomSheetSize: BottomSheetSize = .three
  var feedData: FeedShare?

  // MARK: - Buisiness Logic

  func sharePost() {
    LoadingIndicator.showLoading()

    self.worker?.sharePost(
      feedData: self.feedData,
      completionHandler: { isSuccess, error in

        if isSuccess {
          self.dismissView(action: nil)

        } else {
          guard let error = error else { return }

          self.presentAlert(
            message: error.message,
            confirmAction: {
              self.dismissView(action: nil)
            }
          )
        }
      }
    )
  }

  func fetchBottomSheetOptions() {
    if let districtContent = districtContent {
      self.presenter?.presentDistrictContent(
        content: districtContent,
        districtsType: self.districtsType,
        bottomSheetSize: self.bottomSheetSize
      )
    }

    if let options = options {
      self.presenter?.presentOptions(
        options: options,
        bottomSheetSize: self.bottomSheetSize
      )
    }
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

  func passChallengeSortType(sortType: ChallengeSortType) {
    self.challengeSortDelegate?.getSortType(sortType: sortType)
    self.dismissView(action: nil)
  }

  func navigateToShopSearch() {
    self.router?.navigateToShopSearch()
  }

  func dismissView(action: (() -> Void)?) {
    self.router?.dismissView(action: action)
  }

  private func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: @escaping (() -> Void)
  ) {
    self.presenter?.presentAlert(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
