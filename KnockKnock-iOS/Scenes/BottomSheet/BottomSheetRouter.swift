//
//  BottomSheetRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/26.
//

import UIKit

protocol BottomSheetRouterProtocol: AnyObject {
  static func createBottomSheet(delegate: DistrictSelectDelegate) -> UIViewController

  func passDataToShopSearch(source: BottomSheetViewProtocol, city: String)
  func navigateToShopSearch(source: BottomSheetViewProtocol)
}

final class BottomSheetRouter: BottomSheetRouterProtocol {

  weak var delegate: DistrictSelectDelegate?

  static func createBottomSheet(delegate: DistrictSelectDelegate) -> UIViewController {
    let view = BottomSheetViewController()
    let router = BottomSheetRouter()

    view.router = router
    router.delegate = delegate

    return view
  }

  func passDataToShopSearch(source: BottomSheetViewProtocol, city: String) {
    self.delegate?.fetchSelectedCity(city: city)
    self.navigateToShopSearch(source: source)
  }

  func navigateToShopSearch(source: BottomSheetViewProtocol) {
    if let sourceView = source as? UIViewController {
      sourceView.dismiss(animated: true)
    }
  }
}
