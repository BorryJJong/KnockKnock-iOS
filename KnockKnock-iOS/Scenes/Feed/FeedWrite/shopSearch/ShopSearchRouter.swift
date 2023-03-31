//
//  ShopSearchRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchRouterProtocol: AnyObject {
  var view: ShopSearchViewProtocol? { get set }

  static func createShopSearch(delegate: ShopSearchDelegate) -> UIViewController

  func presentBottomSheetView(
    content: [String],
    districtsType: DistrictsType
  )
  func passDataToFeedWriteView(address: AddressResponse.Documents?)
  func navigateToFeedWriteView()
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
  weak var view: ShopSearchViewProtocol?

  static func createShopSearch(delegate: ShopSearchDelegate) -> UIViewController {
    let view = ShopSearchViewController()
    let interactor = ShopSearchInteractor()
    let presenter = ShopSearchPresenter()
    let worker = ShopSearchWorker(repository: ShopSearchRepository())
    let router = ShopSearchRouter()

    view.interactor = interactor
    presenter.view = view
    interactor.worker = worker
    interactor.presenter = presenter
    interactor.router = router
    router.view = view
    router.districtSelectDelegate = interactor
    router.delegate = delegate

    return view
  }

  func passDataToFeedWriteView(address: AddressResponse.Documents?) {
    if let address = address {
      self.delegate?.fetchShopData(shopData: address)
    }
    self.navigateToFeedWriteView()
  }

  func navigateToFeedWriteView() {
    guard let sourceView = self.view as? ShopSearchViewController else { return }
    sourceView.navigationController?.popViewController(animated: true)
  }

  func presentBottomSheetView(
    content: [String],
    districtsType: DistrictsType
  ) {

    guard let bottomSheetViewController = BottomSheetRouter.createBottomSheet(
      districtSelectDelegate: self.districtSelectDelegate,
      districtsType: districtsType,
      districtsContent: content,
      bottomSheetSize: .max
    ) as? BottomSheetViewController else { return }
    
    bottomSheetViewController.modalPresentationStyle = .overFullScreen

    if let sourceView = self.view as? UIViewController {
      sourceView.present(
        bottomSheetViewController,
        animated: false,
        completion: nil
      )
    }
  }
}
