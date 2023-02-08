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
    challengeSortDelegate: ChallengeSortDelegate?,
    deleteAction: (() -> Void)?,
    hideAction: (() -> Void)?,
    editAction: (() -> Void)?,
    reportAction: (() -> Void)?,
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
    challengeSortDelegate: ChallengeSortDelegate? = nil,
    deleteAction: (() -> Void)? = nil,
    hideAction: (() -> Void)? = nil,
    editAction: (() -> Void)? = nil,
    reportAction: (() -> Void)? = nil,
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
    interactor.hideAction = hideAction
    interactor.reportAction = reportAction
    interactor.feedData = feedData

    if let isMyPost = isMyPost {
      router.setBottomSheetOptions(isMyPost: isMyPost)
    }
    
    guard challengeSortDelegate != nil else { return view }
    interactor.challengeSortDelegate = challengeSortDelegate
    router.setChallengeBottomSheetOption()

    interactor.deleteAction = deleteAction
    interactor.editAction = editAction
    interactor.feedData = feedData

    return view
  }

  private func setChallengeBottomSheetOption() {
    guard let view = self.view as? BottomSheetViewController else { return }

    view.setBottomSheetContents(
      contents: [
        BottomSheetOption.challengeNew.rawValue,
        BottomSheetOption.challengePopular.rawValue
      ],
      bottomSheetType: BottomSheetType.small
    )
    view.modalPresentationStyle = .overFullScreen
  }
  
  func navigateToShopSearch() {
    if let sourceView = self.view as? UIViewController {
      sourceView.dismiss(animated: true)
    }
  }

  private func setBottomSheetOptions(isMyPost: Bool) {
    guard let view = self.view as? BottomSheetViewController else { return }

    let contents: [String] = {
      if isMyPost {
        return [
          BottomSheetOption.postDelete.rawValue,
          BottomSheetOption.postEdit.rawValue,
          BottomSheetOption.postShare.rawValue
        ]
      } else {
        return [
          BottomSheetOption.postReport.rawValue,
          BottomSheetOption.postShare.rawValue,
          BottomSheetOption.postHide.rawValue
        ]
      }
    }()

    view.setBottomSheetContents(contents: contents, bottomSheetType: .medium)
    view.modalPresentationStyle = .overFullScreen
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
