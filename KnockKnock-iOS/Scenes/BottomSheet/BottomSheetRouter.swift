//
//  BottomSheetRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/26.
//

import UIKit

protocol BottomSheetRouterProtocol: AnyObject {
  static func createBottomSheet(districtSelectDelegate: DistrictSelectDelegate?, districtsType: DistrictsType?) -> UIViewController

  func passCityDataToShopSearch(source: BottomSheetViewProtocol, city: String)
  func passCountyDataToShopSearch(source: BottomSheetViewProtocol, county: String)

  func navigateToShopSearch(source: BottomSheetViewProtocol)
}

final class BottomSheetRouter: BottomSheetRouterProtocol {

  weak var districtSelectDelegate: DistrictSelectDelegate?

  static func createBottomSheet(
    districtSelectDelegate: DistrictSelectDelegate? = nil,
    districtsType: DistrictsType? = nil
  ) -> UIViewController {
    let view = BottomSheetViewController()
    let router = BottomSheetRouter()

    view.router = router
    view.districtsType = districtsType
    router.districtSelectDelegate = districtSelectDelegate

    return view
  }

  func passCityDataToShopSearch(source: BottomSheetViewProtocol, city: String) {
    self.districtSelectDelegate?.fetchSelectedCity(city: city)
    self.navigateToShopSearch(source: source)
  }

  func passCountyDataToShopSearch(source: BottomSheetViewProtocol, county: String) {
    self.districtSelectDelegate?.fetchSelectedCounty(county: county)
    self.navigateToShopSearch(source: source)
  }

  func navigateToShopSearch(source: BottomSheetViewProtocol) {
    if let sourceView = source as? UIViewController {
      sourceView.dismiss(animated: true)
    }
  }
}
