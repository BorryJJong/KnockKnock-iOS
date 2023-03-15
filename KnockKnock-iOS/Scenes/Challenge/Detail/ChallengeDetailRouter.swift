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

  func popChallengeDetailView()
  func presentToFeedWrite(challengeId: Int)
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
}
