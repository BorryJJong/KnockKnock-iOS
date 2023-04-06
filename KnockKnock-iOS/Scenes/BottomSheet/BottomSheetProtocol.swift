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
    options: [BottomSheetOption],
    bottomSheetSize: BottomSheetSize
  )
  func fetchDistrictsContent(
    content: [String],
    districtsType: DistrictsType?,
    bottomSheetSize: BottomSheetSize
  )

  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: @escaping (() -> Void)
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
  func dismissView(action: (() -> Void)?)
}

protocol BottomSheetPresenterProtocol {
  var view: BottomSheetViewProtocol? { get set }

  func presentOptions(
    options: [BottomSheetOption],
    bottomSheetSize: BottomSheetSize
  )
  func presentDistrictContent(
    content: [String],
    districtsType: DistrictsType?,
    bottomSheetSize: BottomSheetSize
  )

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: @escaping (() -> Void)
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
    districtsContent: [String]?,
    challengeSortDelegate: ChallengeSortDelegate?,
    options: [BottomSheetOption]?,
    bottomSheetSize: BottomSheetSize,
    feedData: FeedShare?
  ) -> UIViewController

  func navigateToShopSearch()

  func dismissView(action: (() -> Void)?)
}
