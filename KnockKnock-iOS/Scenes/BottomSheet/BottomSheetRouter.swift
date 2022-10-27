//
//  BottomSheetRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/26.
//

import UIKit

protocol BottomSheetRouterProtocol: AnyObject {
  static func createBottomSheet() -> UIViewController

  func passDataToShopSearch()
  func navigateToShopSearch(source: BottomSheetViewProtocol)
}

final class BottomSheetRouter: BottomSheetRouterProtocol {
  static func createBottomSheet() -> UIViewController {
    let view = BottomSheetViewController()
    let router = BottomSheetRouter()

    view.router = router

    return view
  }

  func passDataToShopSearch() {

  }

  func navigateToShopSearch(source: BottomSheetViewProtocol) {
    
  }
}
