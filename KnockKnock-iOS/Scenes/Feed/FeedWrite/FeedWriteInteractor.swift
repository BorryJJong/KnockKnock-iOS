//
//  FeedWriteInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import Foundation

protocol FeedWriteInteractorProtocol: AnyObject {
  var presenter: FeedWritePresenterProtocol? { get }
  var worker: FeedWriteWorkerProtocol? { get set }
  var router: FeedWriteRouterProtocol? { get set }

  func dismissFeedWriteView(source: FeedWriteViewProtocol)
  func navigateToShopSearch(source: FeedWriteViewProtocol)
  func navigateToProperty(
    source: FeedWriteViewProtocol,
    propertyType: PropertyType
  )
  func checkEssentialField(photoAndContentFilled: Bool)
}

final class FeedWriteInteractor: FeedWriteInteractorProtocol {

  // MARK: - Properties

  var presenter: FeedWritePresenterProtocol?
  var worker: FeedWriteWorkerProtocol?
  var router: FeedWriteRouterProtocol?

  private var selectedPromotionList: [Promotion] = []
  private var selectedTagList: [ChallengeTitle] = []

  // Routing

  func dismissFeedWriteView(source: FeedWriteViewProtocol) {
    self.router?.dismissFeedWriteView(source: source)
  }

  func navigateToShopSearch(source: FeedWriteViewProtocol) {
    self.router?.navigateToShopSearch(source: source)
  }

  func navigateToProperty(
    source: FeedWriteViewProtocol,
    propertyType: PropertyType
  ) {
    self.router?.navigateToProperty(
      source: source,
      propertyType: propertyType,
      promotionList: self.selectedPromotionList,
      tagList: self.selectedTagList
    )
  }

  func checkEssentialField(photoAndContentFilled: Bool) {
    let isPromotionSelected = self.selectedPromotionList.filter {
      $0.isSelected == true
    }.count != 0

    let isTagSelected = self.selectedTagList.filter{
      $0.isSelected == true
    }.count != 0

    if photoAndContentFilled &&
        isTagSelected &&
        isPromotionSelected {
      self.presenter?.presentAlertView(isDone: true)

    } else {
      self.presenter?.presentAlertView(isDone: false)
    }
  }
}

// MARK: - Shop Search Delegate

extension FeedWriteInteractor: ShopSearchDelegate {
  func fetchShopData(shopData: String) {
    self.presenter?.presentShopAddress(address: shopData)
  }
}

// MARK: - Property Delegate(태그, 프로모션)

extension FeedWriteInteractor: PropertyDelegate {
  func fetchSelectedPromotion(promotionList: [Promotion]) {
    self.selectedPromotionList = promotionList

    self.presenter?.presentSelectedPromotions(promotionList: promotionList)
  }

  func fetchSelectedTag(tagList: [ChallengeTitle]) {
    self.selectedTagList = tagList

    self.presenter?.presentSelectedTags(tagList: tagList)
  }
}
