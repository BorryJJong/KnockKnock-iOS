//
//  BottomSheetRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/26.
//

import UIKit

protocol BottomSheetRouterProtocol: AnyObject {
  var view: BottomSheetViewProtocol? { get set }

  static func createBottomSheet(
    districtSelectDelegate: DistrictSelectDelegate?,
    districtsType: DistrictsType?,
    deleteAction: (() -> Void)?,
    feedData: FeedShare?,
    isMyPost: Bool?
  ) -> UIViewController

  func navigateToShopSearch()
  func dismissView(action: (() -> Void)?)
  func presentErrorAlertView(message: String) 
}

final class BottomSheetRouter: BottomSheetRouterProtocol {

  weak var view: BottomSheetViewProtocol?

  static func createBottomSheet(
    districtSelectDelegate: DistrictSelectDelegate? = nil,
    districtsType: DistrictsType? = nil,
    deleteAction: (() -> Void)? = nil,
    feedData: FeedShare? = nil,
    isMyPost: Bool? = nil
  ) -> UIViewController {

    let view = BottomSheetViewController()
    let interactor = BottomSheetInteractor()
    let worker = BottomSheetWorker(kakaoShareManager: KakaoShareManager())
    let router = BottomSheetRouter()

    view.interactor = interactor
    view.districtsType = districtsType
    interactor.router = router
    interactor.worker = worker
    router.view = view

    interactor.districtSelectDelegate = districtSelectDelegate
    interactor.deleteAction = deleteAction
    interactor.feedData = feedData

    guard let isMyPost = isMyPost else { return view }
    router.setBottomSheetOptions(isMyPost: isMyPost)

    return view
  }

  private func setBottomSheetOptions(isMyPost: Bool) {
    guard let view = self.view as? BottomSheetViewController else { return }

    view.do {
      if isMyPost {
        $0.setBottomSheetContents(
          contents: [
            BottomSheetOption.postDelete.rawValue,
            BottomSheetOption.postEdit.rawValue,
            BottomSheetOption.postShare.rawValue
          ],
          bottomSheetType: .medium
        )

      } else {
        $0.setBottomSheetContents(
          contents: [
            BottomSheetOption.postReport.rawValue,
            BottomSheetOption.postShare.rawValue,
            BottomSheetOption.postHide.rawValue
          ],
          bottomSheetType: .medium
        )
      }
      $0.modalPresentationStyle = .overFullScreen
    }
  }

  func presentErrorAlertView(message: String) {
    guard let sourceView = self.view as? UIViewController else { return }

    LoadingIndicator.hideLoading()
    sourceView.showAlert(content: message)
  }

  func navigateToShopSearch() {
    guard let sourceView = self.view as? UIViewController else { return }

    sourceView.dismiss(animated: true)
  }

  func dismissView(action: (() -> Void)?) {
    guard let sourceView = self.view as? UIViewController else { return }

    sourceView.dismiss(animated: false, completion: action)
    LoadingIndicator.hideLoading()
  }
}
