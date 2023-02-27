//
//  BottomSheetRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/26.
//

import UIKit

final class BottomSheetRouter: BottomSheetRouterProtocol {

  weak var view: BottomSheetViewProtocol?

  static func createBottomSheet(
    districtSelectDelegate: DistrictSelectDelegate? = nil,
    districtsType: DistrictsType? = nil,
    districtsContent: [String]? = nil,
    challengeSortDelegate: ChallengeSortDelegate? = nil,
    options: [BottomSheetOption]? = nil,
    bottomSheetSize: BottomSheetSize,
    feedData: FeedShare? = nil
  ) -> UIViewController {

    let view = BottomSheetViewController()
    let interactor = BottomSheetInteractor()
    let presenter = BottomSheetPresenter()
    let worker = BottomSheetWorker(kakaoShareManager: KakaoShareManager())
    let router = BottomSheetRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.worker = worker
    interactor.presenter = presenter
    presenter.view = view
    router.view = view

    interactor.districtsType = districtsType
    interactor.bottomSheetSize = bottomSheetSize
    interactor.districtSelectDelegate = districtSelectDelegate
    interactor.feedData = feedData

    if let options = options {
      interactor.options = options
    }
    if let districtsContent = districtsContent {
      interactor.districtContent = districtsContent
    }

    guard challengeSortDelegate != nil else { return view }
    interactor.challengeSortDelegate = challengeSortDelegate

    return view
  }
  
  func navigateToShopSearch() {
    if let sourceView = self.view as? UIViewController {
      sourceView.dismiss(animated: true)
    }
  }

  func presentErrorAlertView(message: String) {
    guard let sourceView = self.view as? UIViewController else { return }

    LoadingIndicator.hideLoading()

    sourceView.showAlert(
      content: message,
      isCancelActive: false,
      confirmActionCompletion: {
        self.dismissView(action: nil)
      }
    )
  }

  func dismissView(action: (() -> Void)?) {
    guard let sourceView = self.view as? UIViewController else { return }

    sourceView.dismiss(animated: false, completion: action)
    LoadingIndicator.hideLoading()
  }
}
