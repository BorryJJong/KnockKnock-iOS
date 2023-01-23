//
//  BottomSheetRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/26.
//

import UIKit

protocol BottomSheetRouterProtocol: AnyObject {
  var view: BottomSheetViewProtocol? { get set }
  static func createBottomSheet(districtSelectDelegate: DistrictSelectDelegate?, districtsType: DistrictsType?, deleteAction: (() -> Void)?, feedData: FeedList.Post?) -> UIViewController

  func passCityDataToShopSearch(city: String)
  func passCountyDataToShopSearch(county: String)

  func navigateToShopSearch()
}

final class BottomSheetRouter: BottomSheetRouterProtocol {

  weak var districtSelectDelegate: DistrictSelectDelegate?
  weak var view: BottomSheetViewProtocol?

  static func createBottomSheet(
    districtSelectDelegate: DistrictSelectDelegate? = nil,
    districtsType: DistrictsType? = nil,
    deleteAction: (() -> Void)? = nil,
    feedData: FeedList.Post? = nil
  ) -> UIViewController {

    let view = BottomSheetViewController()
    let router = BottomSheetRouter()

    view.router = router
    view.districtsType = districtsType
    router.view = view
    router.districtSelectDelegate = districtSelectDelegate

    view.deleteAction = deleteAction
    view.feedData = feedData

    return view
  }

  func passCityDataToShopSearch(city: String) {
    self.districtSelectDelegate?.fetchSelectedCity(city: city)
    self.navigateToShopSearch()
  }

  func passCountyDataToShopSearch(county: String) {
    self.districtSelectDelegate?.fetchSelectedCounty(county: county)
    self.navigateToShopSearch()
  }

  func navigateToShopSearch() {
    if let sourceView = self.view as? UIViewController {
      sourceView.dismiss(animated: true)
    }
  }
}
