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

  func dismissFeedWriteView()
  func presentFeedWriteCompletedView(feedId: Int)
  func navigateToShopSearch()
  func navigateToProperty(propertyType: PropertyType)

  func setCurrentText(text: String)
  func checkEssentialField(image: [Data?])
  func requestUploadFeed(
    content: String,
    images: [Data?]
  )
}

final class FeedWriteInteractor: FeedWriteInteractorProtocol {

  // MARK: - Properties

  var presenter: FeedWritePresenterProtocol?
  var worker: FeedWriteWorkerProtocol?
  var router: FeedWriteRouterProtocol?

  var challengeId: Int? {
    didSet {
      guard let id = challengeId else { return }
      self.setSelectedChallenge(selectedChallengeId: id)
    }
  }
  private var selectedPromotionList: [Promotion] = []
  private var selectedTagList: [ChallengeTitle] = []
  private var selectedAddress: AddressResponse.Documents?
  private var postContent: String = ""

  // Routing

  func dismissFeedWriteView() {
    self.router?.dismissFeedWriteView(feedId: nil)
  }

  func presentFeedWriteCompletedView(feedId: Int) {
    self.router?.presenetFeedWriteCompletedView(feedId: feedId)
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

  func checkEssentialField(image: [Data?]) {

    guard let isDone = self.worker?.checkEssentialField(
      imageCount: image.count,
      tag: self.selectedTagList,
      promotion: self.selectedPromotionList,
      content: self.postContent
    ) else { return }

    if isDone {
      self.presentAlert(
        message: AlertMessage.feedWriteConfirm.rawValue,
        isCancelActive: true,
        confirmAction: {
          LoadingIndicator.showLoading()

          self.requestUploadFeed(
            content: self.postContent,
            images: image
          )
        }
      )
    } else {
      self.presentAlert(message: AlertMessage.feedWriteNeedFill.rawValue)
    }
  }

  func requestUploadFeed(
    content: String,
    images: [Data?]
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
      ),
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let feedId = response?.data else { return }

        LoadingIndicator.hideLoading()

        DispatchQueue.main.asyncAfter(
          deadline: DispatchTime.now(),
          execute: {
            self.presentFeedWriteCompletedView(feedId: feedId)
          }
        )
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

// MARK: - Inner Actions

extension FeedWriteInteractor {

  /// 기존 글의 챌린지 선택 상태 업데이트
  ///
  /// - Parameters:
  ///  - feedDetail: Api로부터 받아온 기존 게시글 데이터
  private func setSelectedChallenge(
    selectedChallengeId: Int
  ) {

    // 태그(챌린지) 리스트 api
    self.worker?.requestTagList(
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let challenges = response?.data,
              let selectedTagList = self.worker?.selectChallenge(
                selectedChallengeId: selectedChallengeId,
                challenges: challenges
              ) else { return }

        self.selectedTagList = selectedTagList

        self.presenter?.presentSelectedTags(tagList: self.selectedTagList)
      }
    )
  }

  // MARK: - Error

  private func showErrorAlert<T>(response: ApiResponse<T>?) {
    guard let response = response else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.presentAlert(message: AlertMessage.unknownedError.rawValue)
      }
      return
    }

    guard response.data != nil else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.presentAlert(message: response.message)
      }
      return
    }
  }

  private func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    self.presenter?.presentAlert(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
