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
  var view: PropertySelectViewProtocol? { get set }

  static func createPropertySelectView(
    delegate: PropertyDelegate,
    propertyType: PropertyType,
    promotionList: [Promotion]?,
    tagList: [ChallengeTitle]?
  ) -> UIViewController

  func passTagToFeedWriteView(tagList: [ChallengeTitle])
  func passPromotionToFeedWriteView(promotionList: [Promotion])

  func navigateToFeedWriteView()
}

final class PropertySelectRouter: PropertySelectRouterProtocol {

  weak var delegate: PropertyDelegate?
  weak var view: PropertySelectViewProtocol?

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

    view.propertyType = propertyType
    view.interactor = interactor
    interactor.presenter = presenter
    interactor.worker = worker
    interactor.router = router
    presenter.view = view
    router.view = view
    router.delegate = delegate

    if let promotionList = promotionList {
      view.promotionList = promotionList
    }
    if let tagList = tagList {
      view.tagList = tagList
    }

    return view
  }

  func passTagToFeedWriteView(tagList: [ChallengeTitle]) {
    self.delegate?.fetchSelectedTag(tagList: tagList)
    self.navigateToFeedWriteView()
  }

  func passPromotionToFeedWriteView(promotionList: [Promotion]) {
    self.delegate?.fetchSelectedPromotion(promotionList: promotionList)
    self.navigateToFeedWriteView()
  }

  func navigateToFeedWriteView() {
    guard let sourceView = self.view as? UIViewController else { return }
    sourceView.navigationController?.popViewController(animated: true)
  }
}
