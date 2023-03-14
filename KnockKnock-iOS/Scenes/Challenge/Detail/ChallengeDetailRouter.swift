//
//  ChallengeDetailRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/22.
//

import UIKit

protocol ChallengeDetailRouterProtocol {
  var view: ChallengeDetailViewProtocol? { get set }

  static func createChallengeDetail(challengeId: Int) -> UIViewController

  func presentErrorAlertView(message: String)
  func popChallengeDetailView()
  func presentToFeedWrite(challengeId: Int)
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
}

final class ChallengeDetailRouter: ChallengeDetailRouterProtocol {
  weak var view: ChallengeDetailViewProtocol?

  static func createChallengeDetail(challengeId: Int) -> UIViewController {
    let view = ChallengeDetailViewController()
    let interactor = ChallengeDetailInteractor()
    let presenter = ChallengeDetailPresenter()
    let worker = ChallengeDetailWorker(
      repository: ChallengeRepository(),
      kakaoShareManager: KakaoShareManager()
    )
    let router = ChallengeDetailRouter()

    view.interactor = interactor
    view.challengeId = challengeId
    interactor.presenter = presenter
    interactor.worker = worker
    interactor.router = router
    presenter.view = view
    router.view = view

    return view
  }

  func presentErrorAlertView(message: String) {
    guard let sourceView = self.view as? UIViewController else { return }

    LoadingIndicator.hideLoading()
    sourceView.showAlert(content: message)
  }

  func popChallengeDetailView() {
    guard let sourceView = self.view as? UIViewController else { return }

    sourceView.navigationController?.popViewController(animated: true)
  }

  func presentToFeedWrite(challengeId: Int) {

    guard let sourceView = self.view as? UIViewController else { return }

    let feedWriteViewController = UINavigationController(
      rootViewController: FeedWriteRouter.createFeedWrite(
        challengeId: challengeId,
        rootView: sourceView.navigationController
      )
    )

    feedWriteViewController.modalPresentationStyle = .fullScreen

    sourceView.navigationController?.present(feedWriteViewController, animated: true)

  }

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    guard let sourceView = self.view as? UIViewController else { return }

    sourceView.showAlert(
      content: message,
      isCancelActive: false,
      confirmActionCompletion: confirmAction
    )
  }
}
