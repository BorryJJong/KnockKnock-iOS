//
//  PropertySelectRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/21.
//

import UIKit

protocol PropertyDelegate: AnyObject {
  func fetchSelectedPromotion(promotionList: [Promotion])
  func fetchSelectedTag(tagList: [ChallengeTitle])
}

protocol PropertySelectRouterProtocol {
  static func createPropertySelectView(
    delegate: PropertyDelegate,
    propertyType: PropertyType,
    promotionList: [Promotion]?,
    tagList: [ChallengeTitle]?
  ) -> UIViewController

  func passTagToFeedWriteView(
    source: PropertySelectViewProtocol,
    tagList: [ChallengeTitle]
  )
  func passPromotionToFeedWriteView(
    source: PropertySelectViewProtocol,
    promotionList: [Promotion]
  )

  func navigateToFeedWriteView(source: PropertySelectViewProtocol)
}

final class PropertySelectRouter: PropertySelectRouterProtocol {

  weak var delegate: PropertyDelegate?

  static func createPropertySelectView(
    delegate: PropertyDelegate,
    propertyType: PropertyType,
    promotionList: [Promotion]?,
    tagList: [ChallengeTitle]?
  ) -> UIViewController {

    let view = PropertySelectViewController()
    let interactor = PropertySelectInteractor()
    let presenter = PropertySelectPresenter()
    let worker = PropertySelectWorker(repository: FeedWriteRepository())
    let router = PropertySelectRouter()

    view.router = router
    view.propertyType = propertyType
    view.interactor = interactor
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    router.delegate = delegate

    if let promotionList = promotionList {
      view.promotionList = promotionList
    }
    if let tagList = tagList {
      view.tagList = tagList
    }

    return view
  }

  func passTagToFeedWriteView(
    source: PropertySelectViewProtocol,
    tagList: [ChallengeTitle]
  ) {
    self.delegate?.fetchSelectedTag(
      tagList: tagList
    )
    self.navigateToFeedWriteView(source: source)
  }

  func passPromotionToFeedWriteView(
    source: PropertySelectViewProtocol,
    promotionList: [Promotion]
  ) {
    self.delegate?.fetchSelectedPromotion(
      promotionList: promotionList
    )
    self.navigateToFeedWriteView(source: source)
  }

  func navigateToFeedWriteView(source: PropertySelectViewProtocol) {
    guard let sourceView = source as? PropertySelectViewController else { return }
    sourceView.navigationController?.popViewController(animated: true)
  }
}
