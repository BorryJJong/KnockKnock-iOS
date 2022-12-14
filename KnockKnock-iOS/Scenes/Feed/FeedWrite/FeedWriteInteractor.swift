//
//  FeedWriteInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import UIKit
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
  func requestUploadFeed(source: FeedWriteViewProtocol, userId: Int, content: String, images: [UIImage])
}

final class FeedWriteInteractor: FeedWriteInteractorProtocol {

  // MARK: - Properties

  var presenter: FeedWritePresenterProtocol?
  var worker: FeedWriteWorkerProtocol?
  var router: FeedWriteRouterProtocol?

  private var selectedPromotionList: [Promotion] = []
  private var selectedTagList: [ChallengeTitle] = []
  private var selectedAddress: AddressResult.Documents?

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

  func requestUploadFeed(
    source: FeedWriteViewProtocol,
    userId: Int,
    content: String,
    images: [UIImage]
  ) {
    let promotions = self.selectedPromotionList.filter{
      $0.isSelected == true
    }.map {
      String($0.promotionInfo.id)
    }.joined(separator: ",")

    let challenges = self.selectedTagList.filter{
      $0.isSelected == true
    }.map {
      String($0.id)
    }.joined(separator: ",")

    self.worker?.uploadFeed(
      postData: FeedWrite(
        userId: userId,
        content: content,
        storeAddress: self.selectedAddress?.addressName ?? "",
        locationX: self.selectedAddress?.longtitude ?? "",
        locationY: self.selectedAddress?.latitude ?? "",
        scale: "1:1",
        promotions: promotions,
        challenges: challenges,
        images: images
      ),
      completionHandler: {
        // 게시물 등록이 완료되었습니다
        self.dismissFeedWriteView(source: source)
      }
    )
  }
}

// MARK: - Shop Search Delegate

extension FeedWriteInteractor: ShopSearchDelegate {
  func fetchShopData(shopData: AddressResult.Documents) {
    self.selectedAddress = shopData
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
