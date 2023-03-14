//
//  ChallengeDetailInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/22.
//

import Foundation

protocol ChallengeDetailInteractorProtocol {
  var presenter: ChallengeDetailPresenterProtocol? { get set }
  var worker: ChallengeDetailWorkerProtocol? { get set }

  func getChallengeDetail(challengeId: Int)
  func shareChallenge(challengeData: ChallengeDetail?)

  func popChallengeDetailView()
  func presentToFeedWrite(challengeId: Int)
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
}

final class ChallengeDetailInteractor: ChallengeDetailInteractorProtocol {

  // MARK: - Properties

  var presenter: ChallengeDetailPresenterProtocol?
  var worker: ChallengeDetailWorkerProtocol?
  var router: ChallengeDetailRouter?

  // MARK: - Business Logic

  /// 챌린지 상세 조회
  ///
  /// - Parameters:
  ///  - challengeId: 챌린지 id
  func getChallengeDetail(challengeId: Int) {

    LoadingIndicator.showLoading()

    self.worker?.getChallengeDetail(
      challengeId: challengeId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let challengeDetail = response?.data else { return }

        self.presenter?.presentChallengeDetail(challengeDetail: challengeDetail)
      }
    )
  }

  /// 챌린지 공유하기
  ///
  /// - Parameters:
  ///  - challengeData: 챌린지 데이터
  func shareChallenge(challengeData: ChallengeDetail?) {

    LoadingIndicator.showLoading()
    
    self.worker?.shareChallenge(
      challengeData: challengeData,
      completionHandler: { [weak self] isSuccess, error in

        guard let self = self else { return }

        if !isSuccess {
          guard let error = error else { return }

          self.presentAlert(message: error.message)
          
        } else {
          
          LoadingIndicator.hideLoading()
        }
      }
    )
  }

  // MARK: - Routing

  func popChallengeDetailView() {
    self.router?.popChallengeDetailView()
  }

  func presentToFeedWrite(challengeId: Int) {
    self.router?.presentToFeedWrite(challengeId: challengeId)
  }
  
  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    self.presentAlert(
      message: message,
      confirmAction: confirmAction
    )
  }
}

extension ChallengeDetailInteractor {

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
