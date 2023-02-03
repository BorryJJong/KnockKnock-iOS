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
  func updateFeed(id: Int)

  func popFeedEditView()
  func navigateToShopSearch()
  func navigateToProperty(propertyType: PropertyType)
}

final class FeedEditInteractor: FeedEditInteractorProtocol {

  // MARK: - Properties

  var router: FeedEditRouterProtocol?
  var worker: FeedEditWorkerProtocol?
  var presenter: FeedEditPresenterProtocol?

  private var originPromotions: [Promotion] = []
  private var originChallenges: [ChallengeTitle] = []
  private var updatedPromotions: [Promotion] = []
  private var updatedChallenges: [ChallengeTitle] = []

//  private var promotions: [Promotion] = []
//  private var challenges: [ChallengeTitle] = []

  private var selectedAddress: AddressResponse.Documents?
  private var postContent: String = ""
  private var originPostData: FeedDetail?

  // MARK: - Business Logic

  /// 기존 게시글 불러오기
  ///
  /// - Parameters:
  /// - feedId: 피드 아이디
  func fetchOriginPost(feedId: Int) {

    self.worker?.fetchOriginPost(
      feedId: feedId,
      completionHandler: { [weak self] feedDetail in
        /// 기존에 선택 상태에 있던 속성(프로모션, 챌린지) 상태 반영
        self?.originPostData = feedDetail
        self?.setSelectedPromotion(promotions: feedDetail.promotions)
        self?.setSelectedChallenge(challenges: feedDetail.challenges)
        self?.presenter?.presentOriginPost(feedDetail: feedDetail)
      }
    )
  }

  /// interactor에 내용에 입력된 텍스트 업데이트
  func setCurrentText(text: String) {
    self.postContent = text
  }

  func updateFeed(id: Int) {

    let content = self.originPostData?.feed?.content == self.postContent
    ? nil : self.postContent
    
    let addressData = self.originPostData?.feed?.storeAddress == self.selectedAddress?.addressName
    ? nil : self.selectedAddress

    self.worker?.requestFeedEdit(
      id: id,
      postData: FeedEdit(
        promotions: self.getPromotionId(),
        challenges: self.getChallengeId(),
        content: content,
        storeAddress: addressData?.addressName,
        storeName: addressData?.placeName,
        locationX: addressData?.latitude,
        locationY: addressData?.longtitude
      ),
      completionHandler: { isSuccess in
        if isSuccess {
          self.router?.showAlertView(
            message: "수정이 완료되었습니다.",
            confirmAction: {
              self.popFeedEditView()
            }
          )
        } else {
          self.router?.showAlertView(
            message: "수정에 실패하였습니다.",
            confirmAction: nil
          )
        }
      }
    )
  }

  // Routing

  func popFeedEditView() {
    self.router?.popFeedEditView()
  }

  func navigateToShopSearch() {
    self.router?.navigateToShopSearch()
  }

  func navigateToProperty(propertyType: PropertyType) {
    self.router?.navigateToProperty(
      propertyType: propertyType,
      promotionList: self.updatedPromotions,
      tagList: self.updatedChallenges
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
    self.updatedPromotions = promotionList

    self.presenter?.presentSelectedPromotions(promotionList: promotionList)
  }

  func fetchSelectedTag(tagList: [ChallengeTitle]) {
    self.updatedChallenges = tagList

    self.presenter?.presentSelectedTags(tagList: tagList)
  }
}

// MARK: - Inner Actions

extension FeedEditInteractor {

  /// 기존 글의 프로모션 선택 상태 업데이트
  ///
  /// - Parameters:
  /// - promotions: 프로모션 리스트
  private func setSelectedPromotion(promotions: [FeedDetail.Promotion]) {

    // 프로모션 리스트 api
    self.worker?.requestPromotionList(completionHandler: { [weak self] result in
      self?.originPromotions = result
      self?.originPromotions.insert(
        Promotion(
          id: 0,
          type: "없음",
          isSelected: promotions.count == 0
        ), at: 0
      )

      promotions.forEach { selectedPromotion in
        if let index = self?.originPromotions.firstIndex(where: {
          selectedPromotion.promotionId == $0.id
        }) {
          self?.originPromotions[index].isSelected = true
        }
      }

      guard let originPromotions = self?.originPromotions else { return}
      self?.updatedPromotions = originPromotions
    })
  }

  /// 기존 글의 챌린지 선택 상태 업데이트
  ///
  /// - Parameters:
  /// - feedDetail: Api로부터 받아온 기존 게시글 데이터
  private func setSelectedChallenge(challenges: [FeedDetail.Challenge]) {

    // 태그(챌린지) 리스트 api
    self.worker?.requestTagList(completionHandler: { [weak self] result in
      self?.originChallenges = result
      self?.originChallenges.remove(at: 0) // '전체' 컬럼 삭제

      challenges.forEach { selectedChallenge in
        if let index = self?.originChallenges.firstIndex(where: {
          selectedChallenge.challengeId == $0.id
        }) {
          self?.originChallenges[index].isSelected = true
        }
      }

      guard let originChallenges = self?.originChallenges else { return }
      self?.updatedChallenges = originChallenges
    })
  }

  /// 프로모션이 수정되었는지 확인 후 선택 된 프로모션 아이디 추출하여 "1, 2" 형태로 리턴
  /// 이전과 같은 프로모션을 선택했다면 nil 리턴
  private func getPromotionId() -> String? {

    return self.updatedPromotions
      .filter { $0.isSelected == true }
      .map { $0.id }
      .elementsEqual(
        self.originPromotions
          .filter { $0.isSelected == true }
          .map { $0.id }
      )
    ? nil : self.updatedPromotions.filter{
        $0.isSelected == true
      }.map {
        String($0.id)
      }.joined(separator: ",")
  }

  /// 챌린지가 수정 되었는지 확인 후 선택 된 챌린지 아이디 추출하여 "1, 2" 형태로 리턴
  /// 이전과 같은 챌린지를 선택했다면 nil 리턴
  private func getChallengeId() -> String? {

    return self.updatedChallenges
      .filter { $0.isSelected == true }
      .map { $0.id }
      .elementsEqual(
        self.originChallenges
          .filter { $0.isSelected == true }
          .map { $0.id }
      )
    ? nil : self.updatedChallenges.filter{
      $0.isSelected == true
    }.map {
      String($0.id)
    }.joined(separator: ",")

  }
}
