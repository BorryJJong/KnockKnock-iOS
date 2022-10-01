//
//  ShopSearchRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchRouterProtocol: AnyObject {
  static func createShopSearch() -> UIViewController

  func presentBottomSheetView(source: ShopSearchViewProtocol)
  func passToFeedWriteView(source: ShopSearchViewProtocol, address: String)
}

protocol ShopSearchDelegate: AnyObject {
  func getAddress(address: String)
}

final class ShopSearchRouter: ShopSearchRouterProtocol {

  var shopSearchDelegate: ShopSearchDelegate?

  static func createShopSearch() -> UIViewController {

    let view = ShopSearchViewController()
    let interactor = ShopSearchInteractor()
    let presenter = ShopSearchPresenter()
    let worker = ShopSearchWorker(repository: ShopSearchRepository())
    let router = ShopSearchRouter()

    view.interactor = interactor
    view.router = router
    presenter.view = view
    interactor.worker = worker
    interactor.presenter = presenter

    return view
  }

  func passToFeedWriteView(source: ShopSearchViewProtocol, address: String) {
    if let sourceView = source as? UIViewController {
      self.shopSearchDelegate?.getAddress(address: address)
      sourceView.navigationController?.popViewController(animated: true)
    }
  }

  func presentBottomSheetView(source: ShopSearchViewProtocol) {
    let bottomSheetViewController = BottomSheetViewController().then {
      $0.setBottomSheetContents(
        contents: [
          BottomSheetOption.delete.rawValue,
          BottomSheetOption.edit.rawValue
        ])
      $0.modalPresentationStyle = .overFullScreen
    }
    if let sourceView = source as? UIViewController {
      sourceView.present(
        bottomSheetViewController,
        animated: false,
        completion: nil
      )
    }
  }
}
