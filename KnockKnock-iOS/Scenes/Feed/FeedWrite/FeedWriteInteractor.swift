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
  func fetchSelectedPromotion(selection: [Promotion]) {
    let promotion = selection.map {
      $0.type
    }
    let content = promotion.joined(separator: ", ")

    self.presenter?.fetchProperty(propertyType: PropertyType.promotion, content: content)
  }

  func fetchSelectedTag(selection: [ChallengeTitle]) {
    let tag = selection.map {
      $0.title
    }
    let content = tag.joined(separator: ", ")

    self.presenter?.fetchProperty(propertyType: PropertyType.tag, content: content)
  }
}
