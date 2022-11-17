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
}

final class FeedWriteInteractor: FeedWriteInteractorProtocol {

  // MARK: - Properties

  var presenter: FeedWritePresenterProtocol?
  var worker: FeedWriteWorkerProtocol?

  func fetchPromotion(promotionList: [Promotion]) {
    self.presenter?.presentSelectedPromotions(promotionList: promotionList)
  }

  func fetchTag(tagList: [ChallengeTitle]) {
    self.presenter?.presentSelectedTags(tagList: tagList)
  }
}

extension FeedWriteInteractor: ShopSearchDelegate {
  func fetchShopData(shopData: String) {
    self.presenter?.fetchProperty(
      propertyType: .address,
      content: shopData
    )
  }
}

extension FeedWriteInteractor: PropertyDelegate {
  func fetchSelectedPromotion(promotionList: [Promotion]) {
    self.fetchPromotion(promotionList: promotionList)

    let selection = promotionList.filter { $0.isSelected == true }

    var content = selection.map {
      $0.promotionInfo.type
    }.joined(separator: ", ")

    if selection.isEmpty {
      content = "프로모션"
    }

    self.presenter?.fetchProperty(
      propertyType: PropertyType.promotion,
      content: content
    )
  }

  func fetchSelectedTag(tagList: [ChallengeTitle]) {
    self.fetchTag(tagList: tagList)

    let selection = tagList.filter { $0.isSelected == true }

    var content = selection.map {
      $0.title
    }.joined(separator: ", ")

    if selection.isEmpty {
      content = "#태그"
    }

    self.presenter?.fetchProperty(
      propertyType: PropertyType.tag,
      content: content
    )
  }
}
