//
//  ChallengeRouter.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/03.
//

import UIKit

protocol ChallengeRouterProtocol: AnyObject {
  var view: ChallengeViewProtocol? { get set }

  static func createChallenge() -> UIViewController

  func navigateToChallengeDetail(challengeId: Int)
  func presentBottomSheet(challengeSortDelegate: ChallengeSortDelegate)
}

protocol ChallengeSortDelegate: AnyObject {
  func getSortType(sortType: ChallengeSortType)
}

final class ChallengeRouter: ChallengeRouterProtocol {

  weak var view: ChallengeViewProtocol?

  static func createChallenge() -> UIViewController {
    let view = ChallengeViewController()
    let interactor = ChallengeInteractor()
    let presenter = ChallengePresenter()
    let worker = ChallengeWorker(repository: ChallengeRepository())
    let router = ChallengeRouter()
    
    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    router.view = view
    
    return view
  }

  func presentBottomSheet(challengeSortDelegate: ChallengeSortDelegate) {
    guard let sourceView = self.view as? UIViewController else { return }

    let bottomSheetViewController = BottomSheetRouter.createBottomSheet(
      challengeSortDelegate: challengeSortDelegate,
      options: [
        BottomSheet(
          option: BottomSheetOption.challengeNew.rawValue,
          action: nil
        ),
        BottomSheet(
          option: BottomSheetOption.challengePopular.rawValue,
          action: nil
        )
      ],
      type: .small
    )

    bottomSheetViewController.modalPresentationStyle = .overFullScreen

    sourceView.present(
      bottomSheetViewController,
      animated: false,
      completion: nil
    )
  }

  func navigateToChallengeDetail(challengeId: Int) {
    let challengeDetailViewController = ChallengeDetailRouter.createChallengeDetail(
      challengeId: challengeId
    )
    challengeDetailViewController.hidesBottomBarWhenPushed = true
    
    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.pushViewController(
        challengeDetailViewController,
        animated: true
      )
    }
  }
}
