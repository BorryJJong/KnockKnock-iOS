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
  func passDataToFeedWriteView(source: ShopSearchViewProtocol, address: AddressResponse.Documents?)
  func navigateToFeedWriteView(source: ShopSearchViewProtocol)
}

protocol ShopSearchDelegate: AnyObject {
  func fetchShopData(shopData: AddressResponse.Documents)
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
    address: AddressResponse.Documents?
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
      districtSelectDelegate: self.districtSelectDelegate,
      districtsType: districtsType,
      options: content.map { BottomSheet(option: $0, action: nil) },
      type: .large
    ) as? BottomSheetViewController else { return }
    
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
