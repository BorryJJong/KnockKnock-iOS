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

  func fetchProperty(selections: [Any]) {
    self.presenter?.presentSelectedProperty(selections: selections)
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
    self.fetchProperty(selections: promotionList)

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
    self.fetchProperty(selections: tagList)

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
