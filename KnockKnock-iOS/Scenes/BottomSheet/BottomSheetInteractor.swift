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

  var options: [BottomSheet] = []
  var bottomSheetType: BottomSheetSize = .medium
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

  func fetchBottomSheetOptions() {
    self.presenter?.presentOptions(
      options: self.options.map{ $0.option },
      bottomSheetType: self.bottomSheetType
    )
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
    self.dismissView(actionType: .challengeNew)
  }

  func navigateToShopSearch() {
    self.router?.navigateToShopSearch()
  }

  func dismissView(actionType: BottomSheetOption) {

    self.options.forEach {
      if BottomSheetOption(rawValue: $0.option) == actionType {
        self.router?.dismissView(action: $0.action)
      }
    }
  }
}
