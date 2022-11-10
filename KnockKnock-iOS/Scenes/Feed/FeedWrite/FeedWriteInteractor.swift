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
  func fetchSelectedPromotion(selection: [SelectablePromotion]) {
    let content = selection.map {
      $0.promotionInfo.type
    }.joined(separator: ", ")

    self.presenter?.fetchProperty(
      propertyType: PropertyType.promotion,
      content: content
    )
  }

  func fetchSelectedTag(selection: [ChallengeTitle]) {
    let content = selection.map {
      $0.title
    }.joined(separator: ", ")

    self.presenter?.fetchProperty(propertyType: PropertyType.tag, content: content)
  }
}
