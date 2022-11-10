//
//  PropertySelectRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/21.
//

import UIKit

protocol PropertyDelegate: AnyObject {
  func fetchSelectedPromotion(selection: [SelectablePromotion])
  func fetchSelectedTag(selection: [ChallengeTitle])
}

protocol PropertySelectRouterProtocol {
  static func createPropertySelectView(
    delegate: PropertyDelegate,
    propertyType: PropertyType
  ) -> UIViewController

  func passTagToFeedWriteView(
    source: PropertySelectViewProtocol,
    selectedTag: [ChallengeTitle]
  )
  func passPromotionToFeedWriteView(
    source: PropertySelectViewProtocol,
    selectedPromotion: [SelectablePromotion]
  )

  func navigateToFeedWriteView(source: PropertySelectViewProtocol)
}

final class PropertySelectRouter: PropertySelectRouterProtocol {

  weak var delegate: PropertyDelegate?

  static func createPropertySelectView(
    delegate: PropertyDelegate,
    propertyType: PropertyType
  ) -> UIViewController {

    let view = PropertySelectViewController()
    let interactor = PropertySelectInteractor()
    let presenter = PropertySelectPresenter()
    let worker = PropertySelectWorker(repository: FeedRepository())
    let router = PropertySelectRouter()

    view.router = router
    view.propertyType = propertyType
    view.interactor = interactor
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    router.delegate = delegate

    return view
  }

  func passTagToFeedWriteView(
    source: PropertySelectViewProtocol,
    selectedTag: [ChallengeTitle]
  ) {
    self.delegate?.fetchSelectedTag(
      selection: selectedTag
    )
    self.navigateToFeedWriteView(source: source)
  }

  func passPromotionToFeedWriteView(
    source: PropertySelectViewProtocol,
    selectedPromotion: [SelectablePromotion]
  ) {
    let promotion = selectedPromotion.filter { $0.isSelected == true }

    self.delegate?.fetchSelectedPromotion(
      selection: promotion
    )
    self.navigateToFeedWriteView(source: source)
  }

  func navigateToFeedWriteView(source: PropertySelectViewProtocol) {
    guard let sourceView = source as? PropertySelectViewController else { return }
    sourceView.navigationController?.popViewController(animated: true)
  }
}
