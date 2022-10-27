//
//  ShopSearchRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchRouterProtocol: AnyObject {
  static func createShopSearch() -> UIViewController

  func presentBottomSheetView(source: ShopSearchViewProtocol, content: [String])
  func passToFeedWriteView(source: ShopSearchViewProtocol, address: String?)
}

protocol DistrictSelectDelegate: AnyObject {
  func fetchSelectedCity(city: String)
} 

final class ShopSearchRouter: ShopSearchRouterProtocol {

  var districtSelectDelegate: DistrictSelectDelegate?

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
    router.districtSelectDelegate = interactor

    return view
  }

  func passToFeedWriteView(
    source: ShopSearchViewProtocol,
    address: String?
  ) {
    guard let sourceView = source as? ShopSearchViewController else { return }

    if let index = sourceView.navigationController?.viewControllers.count,
       let feedWriteViewController = sourceView.navigationController?.viewControllers[index - 2] as? FeedWriteViewProtocol,
       let address = address {
      feedWriteViewController.getAddress(address: address)
    }
    sourceView.navigationController?.popViewController(animated: true)
  }

  func presentBottomSheetView(source: ShopSearchViewProtocol, content: [String]) {
    if let bottomSheetViewController = BottomSheetRouter.createBottomSheet(delegate: self.districtSelectDelegate!) as? BottomSheetViewController {
      bottomSheetViewController.setBottomSheetContents(contents: content)
      bottomSheetViewController.modalPresentationStyle = .overFullScreen

      if let sourceView = source as? UIViewController {
        sourceView.present(
          bottomSheetViewController,
          animated: false,
          completion: nil
        )
      }
    }
  }
}
