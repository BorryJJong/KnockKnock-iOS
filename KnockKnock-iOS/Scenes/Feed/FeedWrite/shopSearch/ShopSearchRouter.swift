//
//  ShopSearchRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchRouterProtocol: AnyObject {
  static func createShopSearch(delegate: ShopSearchDelegate) -> UIViewController

  func presentBottomSheetView(source: ShopSearchViewProtocol, content: [String], districtsType: DistrictsType)
  func passDataToFeedWriteView(source: ShopSearchViewProtocol, address: AddressDocuments?)
  func navigateToFeedWriteView(source: ShopSearchViewProtocol)
}

protocol ShopSearchDelegate: AnyObject {
  func fetchShopData(shopData: AddressDocuments)
}

protocol DistrictSelectDelegate: AnyObject {
  func fetchSelectedCity(city: String)
  func fetchSelectedCounty(county: String)
} 

final class ShopSearchRouter: ShopSearchRouterProtocol {

  weak var districtSelectDelegate: DistrictSelectDelegate?
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
    router.districtSelectDelegate = interactor
    router.delegate = delegate

    return view
  }

  func passDataToFeedWriteView(
    source: ShopSearchViewProtocol,
    address: AddressDocuments?
  ) {
    if let address = address {
      self.delegate?.fetchShopData(shopData: address)
    }
    self.navigateToFeedWriteView(source: source)
  }

  func navigateToFeedWriteView(source: ShopSearchViewProtocol) {
    guard let sourceView = source as? ShopSearchViewController else { return }
    sourceView.navigationController?.popViewController(animated: true)
  }

  func presentBottomSheetView(
    source: ShopSearchViewProtocol,
    content: [String],
    districtsType: DistrictsType
  ) {
    guard let bottomSheetViewController = BottomSheetRouter.createBottomSheet(
      delegate: self.districtSelectDelegate!,
      districtsType: districtsType
    ) as? BottomSheetViewController else { return }

    bottomSheetViewController.setBottomSheetContents(contents: content, bottomSheetType: .large)
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
