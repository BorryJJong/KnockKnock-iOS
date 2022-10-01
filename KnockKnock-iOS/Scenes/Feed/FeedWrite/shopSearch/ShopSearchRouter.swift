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

final class ShopSearchRouter: ShopSearchRouterProtocol {

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

  func passToFeedWriteView(
    source: ShopSearchViewProtocol,
    address: String
  ) {
    if let sourceView = source as? ShopSearchViewController,
       let index = sourceView.navigationController?.viewControllers.count,
       let feedWriteViewController = sourceView.navigationController?.viewControllers[index - 2] as? FeedWriteViewProtocol {
      feedWriteViewController.getAddress(address: address)
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
