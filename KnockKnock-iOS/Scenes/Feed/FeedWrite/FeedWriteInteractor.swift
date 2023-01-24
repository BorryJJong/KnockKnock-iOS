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

  func dismissFeedWriteView()
  func navigateToShopSearch()
  func navigateToProperty(propertyType: PropertyType)

  func setCurrentText(text: String) 
  func checkEssentialField(imageCount: Int)
  func requestUploadFeed(content: String, images: [UIImage])
}

final class FeedWriteInteractor: FeedWriteInteractorProtocol {

  // MARK: - Properties

  var presenter: FeedWritePresenterProtocol?
  var worker: FeedWriteWorkerProtocol?
  var router: FeedWriteRouterProtocol?

  private var selectedPromotionList: [Promotion] = []
  private var selectedTagList: [ChallengeTitle] = []
  private var selectedAddress: AddressResponse.Documents?
  private var postContent: String = ""

  // Routing

  func dismissFeedWriteView() {
    self.router?.presenetFeedWriteCompletedView()
  }

  func navigateToShopSearch() {
    self.router?.navigateToShopSearch()
  }

  func navigateToProperty(propertyType: PropertyType) {
    self.router?.navigateToProperty(
      propertyType: propertyType,
      promotionList: self.selectedPromotionList,
      tagList: self.selectedTagList
    )
  }

  // Buisness Logic

  func setCurrentText(text: String) {
    self.postContent = text
  }

  func checkEssentialField(imageCount: Int) {
    guard let isDone = self.worker?.checkEssentialField(
      imageCount: imageCount,
      tag: self.selectedTagList,
      promotion: self.selectedPromotionList,
      content: self.postContent
    ) else { return }

    self.presenter?.presentAlertView(isDone: isDone)
  }

  func requestUploadFeed(
    content: String,
    images: [UIImage]
  ) {
    let promotions = self.selectedPromotionList.filter{
      $0.isSelected == true
    }.map {
      String($0.id)
    }.joined(separator: ",")

    let challenges = self.selectedTagList.filter{
      $0.isSelected == true
    }.map {
      String($0.id)
    }.joined(separator: ",")

    self.worker?.uploadFeed(
      postData: FeedWrite(
        content: content,
        storeAddress: self.selectedAddress?.addressName,
        storeName: self.selectedAddress?.placeName,
        locationX: self.selectedAddress?.longtitude ?? "",
        locationY: self.selectedAddress?.latitude ?? "",
        scale: "1:1",
        promotions: promotions,
        challenges: challenges,
        images: images
      ), completionHandler: {
        LoadingIndicator.hideLoading()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
          self.dismissFeedWriteView()
        })
      }
    )
  }
}

// MARK: - Shop Search Delegate

extension FeedWriteInteractor: ShopSearchDelegate {
  func fetchShopData(shopData: AddressResponse.Documents) {
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
