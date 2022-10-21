//
//  ShopSearchRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchRouterProtocol: AnyObject {
  static func createShopSearch(delegate: ShopSearchDelegate) -> UIViewController

  func presentBottomSheetView(source: ShopSearchViewProtocol, content: [String])
  func passToFeedWriteView(source: ShopSearchViewProtocol, address: String?)
}

protocol ShopSearchDelegate: AnyObject {
  func getShopData(shopData: String)
}

final class ShopSearchRouter: ShopSearchRouterProtocol {

  weak var delegate: ShopSearchDelegate?

  static func createShopSearch(delegate: ShopSearchDelegate) -> UIViewController {

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
    router.delegate = delegate

    return view
  }

  func passToFeedWriteView(
    source: ShopSearchViewProtocol,
    address: String?
  ) {
    guard let sourceView = source as? ShopSearchViewController else { return }

    if let address = address {
      self.delegate?.getShopData(shopData: address)
    }
    sourceView.navigationController?.popViewController(animated: true)
  }

  func presentBottomSheetView(source: ShopSearchViewProtocol, content: [String]) {
    let bottomSheetViewController = BottomSheetViewController().then {
      $0.setBottomSheetContents(contents: content)
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
