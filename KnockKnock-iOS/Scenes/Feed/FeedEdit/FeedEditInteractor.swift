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

  private var promotions: [Promotion] = []
  private var challenges: [ChallengeTitle] = []

  private var selectedAddress: AddressResponse.Documents?
  private var postContent: String = ""

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
        self?.setSelectedPromotion(selectedPromotions: feedDetail.promotions)
        self?.setSelectedChallenge(selectedChallenges: feedDetail.challenges)
        self?.presenter?.presentOriginPost(feedDetail: feedDetail)
      }
    )
  }

  /// interactor에 내용에 입력된 텍스트 업데이트
  func setCurrentText(text: String) {
    self.postContent = text
  }

  /// 피드 수정 이벤트
  ///
  /// - Parameters:
  ///  - id: 피드 아이디
  func updateFeed(id: Int) {

    let content = self.postContent
    let addressData = self.selectedAddress

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

// MARK: - Inner Actions

extension FeedEditInteractor {

  /// 기존 글의 프로모션 선택 상태 업데이트
  ///
  /// - Parameters:
  ///  - promotions: 프로모션 리스트
  private func setSelectedPromotion(selectedPromotions: [FeedDetail.Promotion]) {

    // 프로모션 리스트 api
    self.worker?.requestPromotionList(completionHandler: { [weak self] result in
      self?.promotions = result
      self?.promotions.insert(
        Promotion(
          id: 0,
          type: "없음",
          isSelected: self?.promotions.count == 0
        ), at: 0
      )

      selectedPromotions.forEach { selectedPromotion in
        if let index = self?.promotions.firstIndex(where: {
          selectedPromotion.promotionId == $0.id
        }) {
          self?.promotions[index].isSelected = true
        }
      }
    })
  }

  /// 기존 글의 챌린지 선택 상태 업데이트
  ///
  /// - Parameters:
  ///  - feedDetail: Api로부터 받아온 기존 게시글 데이터
  private func setSelectedChallenge(selectedChallenges: [FeedDetail.Challenge]) {

    // 태그(챌린지) 리스트 api
    self.worker?.requestTagList(completionHandler: { [weak self] result in
      self?.challenges = result
      self?.challenges.remove(at: 0) // '전체' 컬럼 삭제

      selectedChallenges.forEach { selectedChallenge in
        if let index = self?.challenges.firstIndex(where: {
          selectedChallenge.challengeId == $0.id
        }) {
          self?.challenges[index].isSelected = true
        }
      }
    })
  }

  /// 선택 된 프로모션 아이디를 추출하여 "1, 2" 형태로 리턴
  private func getPromotionId() -> String {

    return self.promotions.filter{
      $0.isSelected == true
    }.map {
      String($0.id)
    }.joined(separator: ",")
  }

  /// 선택 된 챌린지 아이디를 추출하여 "1, 2" 형태로 리턴
  private func getChallengeId() -> String {

    return self.challenges.filter{
      $0.isSelected == true
    }.map {
      String($0.id)
    }.joined(separator: ",")

  }
}
