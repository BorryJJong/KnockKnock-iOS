//
//  BottomSheetProtocol.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/26.
//

import UIKit

protocol BottomSheetViewProtocol: AnyObject {
  var interactor: BottomSheetInteractorProtocol? { get set }

  func fetchOptions(
    options: [String],
    bottomSheetType: BottomSheetType
  )
}

protocol BottomSheetInteractorProtocol {
  var router: BottomSheetRouterProtocol? { get set }
  var worker: BottomSheetWorkerProtocol? { get set }
  var presenter: BottomSheetPresenterProtocol? { get set }

  func sharePost()
  func fetchBottomSheetOptions()

  func passCityDataToShopSearch(city: String)
  func passCountyDataToShopSearch(county: String)
  func passChallengeSortType(sortType: ChallengeSortType)

  func navigateToShopSearch()
  func dismissView(actionType: BottomSheet.Option)
}

protocol BottomSheetPresenterProtocol {
  var view: BottomSheetViewProtocol? { get set }

  func presentOptions(
    options: [String],
    bottomSheetType: BottomSheetType
  )
}

protocol BottomSheetWorkerProtocol {
  func sharePost(
    feedData: FeedShare?,
    completionHandler: @escaping (Bool, KakaoShareErrorType?) -> Void
  )
}

protocol BottomSheetRouterProtocol: AnyObject {
  var view: BottomSheetViewProtocol? { get set }

  static func createBottomSheet(
    districtSelectDelegate: DistrictSelectDelegate?,
    districtsType: DistrictsType?,
    challengeSortDelegate: ChallengeSortDelegate?,
    options: [BottomSheet],
    type: BottomSheetType,
    feedData: FeedShare?
  ) -> UIViewController

  func navigateToShopSearch()

  func dismissView(action: (() -> Void)?)
  func presentErrorAlertView(message: String)
}
