//
//  ChallengeInteractor.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/03.
//

import Foundation

protocol ChallengeInteractorProtocol: AnyObject {
  var presenter: ChallengePresenterProtocol? { get set }
  var worker: ChallengeWorkerProtocol? { get set }
  
  func fetchChallenge(sortType: ChallengeSortType)
  func presentBottomSheet()
  func navigateToChallengeDetail(challengeId: Int)
}

final class ChallengeInteractor: ChallengeInteractorProtocol {
  
  // MARK: - Properties
  
  var presenter: ChallengePresenterProtocol?
  var worker: ChallengeWorkerProtocol?
  var router: ChallengeRouterProtocol?
  
  func fetchChallenge(sortType: ChallengeSortType) {
    LoadingIndicator.showLoading()

    self.worker?.fetchChallenge(
      sortType: sortType,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let challenges = response?.data else { return }

        self.presenter?.presentFetchChallenge(
          challenges: challenges,
          sortType: sortType
        )
      }
    )
  }

  // MARK: - Routing

  func presentBottomSheet() {
    self.router?.presentBottomSheet(challengeSortDelegate: self)
  }

  func navigateToChallengeDetail(challengeId: Int) {
    self.router?.navigateToChallengeDetail(challengeId: challengeId)
  }
}

extension ChallengeInteractor: ChallengeSortDelegate {
  
  func getSortType(sortType: ChallengeSortType) {
    self.fetchChallenge(sortType: sortType)
  }

  // MARK: - Error

  private func showErrorAlert<T>(response: ApiResponse<T>?) {
    guard let response = response else {
      DispatchQueue.main.async {
        LoadingIndicator.hideLoading()

        self.presentAlert(message: "네트워크 연결을 확인해 주세요.")
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
