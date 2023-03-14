//
//  PropertySelectInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/04.
//

import Foundation

protocol PropertySelectInteractorProtocol {
  var worker: PropertySelectWorkerProtocol? { get set }
  var presenter: PropertySelectPresenterProtocol? { get set }
  var router: PropertySelectRouterProtocol? { get set }

  func fetchPromotionList()
  func fetchTagList()

  func passTagToFeedWriteView(tagList: [ChallengeTitle])
  func passPromotionToFeedWriteView(promotionList: [Promotion])

  func navigateToFeedWriteView()
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
}

final class PropertySelectInteractor: PropertySelectInteractorProtocol {

  var worker: PropertySelectWorkerProtocol?
  var presenter: PropertySelectPresenterProtocol?
  var router: PropertySelectRouterProtocol?

  func fetchPromotionList() {
    self.worker?.requestPromotionList(
      completionHandler: { [weak self] response in
        
        guard let self = self else { return }
        
        self.showErrorAlert(response: response)
        
        guard let promotions = response?.data else { return }
        
        let promotionList = promotions.map {
          Promotion(
            id: $0.id,
            type: $0.type,
            isSelected: false
          )
        }
        self.presenter?.presentPromotionList(promotionList: promotionList)
      }
    )
  }

  func fetchTagList() {
    self.worker?.requestTagList(
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let tagList = response?.data else { return }

        self.presenter?.presentTagList(tagList: tagList)
      }
    )
  }

  func passTagToFeedWriteView(tagList: [ChallengeTitle]) {
    self.router?.passTagToFeedWriteView(tagList: tagList)
  }

  func passPromotionToFeedWriteView(promotionList: [Promotion]) {
    self.router?.passPromotionToFeedWriteView(promotionList: promotionList)
  }

  func navigateToFeedWriteView() {
    self.router?.navigateToFeedWriteView()
  }

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    self.router?.showAlertView(
      message: message,
      confirmAction: confirmAction
    )
  }
}

extension PropertySelectInteractor {

  // MARK: - Error

  private func showErrorAlert<T>(response: ApiResponse<T>?) {
    guard let response = response else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.showAlertView(
          message: "네트워크 연결을 확인해 주세요.",
          confirmAction: nil
        )
      }
      return
    }

    guard response.data != nil else {

      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.showAlertView(
          message: response.message,
          confirmAction: nil
        )
      }
      return
    }
  }
}
