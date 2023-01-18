//
//  FeedEditInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

protocol FeedEditInteractorProtocol: AnyObject {
  var router: FeedEditRouterProtocol? { get set }
  var worker: FeedEditWorkerProtocol? { get set }
  var presenter: FeedEditPresenterProtocol? { get set }

  func fetchOriginPost(feedId: Int)
  func setCurrentText(text: String)

  func dismissFeedWriteView()
  func navigateToShopSearch()
  func navigateToProperty(propertyType: PropertyType)
}

final class FeedEditInteractor: FeedEditInteractorProtocol {

  // MARK: - Properties

  var router: FeedEditRouterProtocol?
  var worker: FeedEditWorkerProtocol?
  var presenter: FeedEditPresenterProtocol?

  private var promotions: [Promotion] = []
  private var challenges: [ChallengeTitle] = []
  private var selectedAddress: AddressResponse.Documents?
  private var postContent: String = ""

  // MARK: - Business Logic

  func fetchOriginPost(feedId: Int) {

    self.worker?.fetchOriginPost(
      feedId: feedId,
      completionHandler: { [weak self] feedDetail in
        self?.setSelectedProperties(feedDetail: feedDetail)
        self?.presenter?.presentOriginPost(feedDetail: feedDetail)
      }
    )
  }

  func setCurrentText(text: String) {
    self.postContent = text
  }

  func setSelectedProperties(feedDetail: FeedDetail) {

    self.worker?.requestPromotionList(completionHandler: { [weak self] result in
      self?.promotions = result
      self?.promotions.insert(
        Promotion(
          id: 0,
          type: "없음",
          isSelected: feedDetail.promotions.count == 0
        ), at: 0
      )

      feedDetail.promotions.forEach { selectedPromotion in
        if let index = self?.promotions.firstIndex(where: {
          selectedPromotion.promotionId == $0.id
        }) {
          self?.promotions[index].isSelected = true
        }
      }
    })

    self.worker?.requestTagList(completionHandler: { [weak self] result in
      self?.challenges = result
      self?.challenges.remove(at: 0) // '전체' 컬럼 삭제

      feedDetail.challenges.forEach { selectedChallenge in
        if let index = self?.challenges.firstIndex(where: {
          selectedChallenge.challengeId == $0.id
        }) {
          self?.challenges[index].isSelected = true
        }
      }
    })
  }

  // Routing

  func dismissFeedWriteView() {
    self.router?.dismissFeedWriteView()
  }

  func navigateToShopSearch() {
    self.router?.navigateToShopSearch()
  }

  func navigateToProperty(propertyType: PropertyType) {
    self.router?.navigateToProperty(
      propertyType: propertyType,
      promotionList: self.promotions,
      tagList: self.challenges
    )
  }
}

// MARK: - Shop Search Delegate

extension FeedEditInteractor: ShopSearchDelegate {
  func fetchShopData(shopData: AddressResponse.Documents) {
    self.selectedAddress = shopData
    self.presenter?.presentShopAddress(address: shopData)
  }
}

// MARK: - Property Delegate(태그, 프로모션)

extension FeedEditInteractor: PropertyDelegate {
  func fetchSelectedPromotion(promotionList: [Promotion]) {
    self.promotions = promotionList

    self.presenter?.presentSelectedPromotions(promotionList: promotionList)
  }

  func fetchSelectedTag(tagList: [ChallengeTitle]) {
    self.challenges = tagList

    self.presenter?.presentSelectedTags(tagList: tagList)
  }
}
