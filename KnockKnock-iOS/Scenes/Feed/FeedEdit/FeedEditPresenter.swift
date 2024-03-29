//
//  FeedEditPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import Foundation

protocol FeedEditPresenterProtocol: AnyObject {
  var view: FeedEditViewProtocol? { get set }
  
  func presentOriginPost(feedDetail: FeedDetail)
  func presentSelectedPromotions(promotionList: [Promotion])
  func presentSelectedTags(tagList: [ChallengeTitle])
  func presentShopAddress(address: AddressResponse.Documents)
  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class FeedEditPresenter: FeedEditPresenterProtocol {

  weak var view: FeedEditViewProtocol?

  func presentOriginPost(feedDetail: FeedDetail) {
    self.view?.fetchOriginPost(feedDetail: feedDetail)
  }

  func presentSelectedPromotions(promotionList: [Promotion]) {
    let selection = promotionList.filter { $0.isSelected == true }

    var content = selection.map {
      $0.type
    }.joined(separator: ", ")

    if selection.isEmpty {
      content = "프로모션"
    }
    self.view?.fetchPromotion(promotion: content)
  }

  func presentSelectedTags(tagList: [ChallengeTitle]) {
    let selection = tagList.filter { $0.isSelected == true }

    var content = selection.map {
      $0.title
    }.joined(separator: ", ")

    if selection.isEmpty {
      content = "#태그"
    }
    self.view?.fetchTag(tag: content)
  }
  
  func presentShopAddress(address: AddressResponse.Documents) {
    self.view?.fetchAddress(address: address)
  }

  func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    self.view?.showAlertView(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
