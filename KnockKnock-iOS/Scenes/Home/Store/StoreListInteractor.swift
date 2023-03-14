//
//  StoreListInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/24.
//

import Foundation

final class StoreListInteractor: StoreListInteractorProtocol {

  // MARK: - Properties

  var router: StoreListRouterProtocol?
  var presenter: StoreListPresentorProtocol?
  var repository: VerifiedStoreRepositoryProtocol?

  init(repository: VerifiedStoreRepositoryProtocol) {
    self.repository = repository
  }

  func fetchStoreDetailList() {
    Task {
      let response = await self.repository?.requestVerifiedStoreDetailList()

      await MainActor.run {
        self.showErrorAlert(response: response)
      }

      guard let storeList = response?.data else { return }

      self.presenter?.presentStoreList(storeList: storeList)
    }
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

extension StoreListInteractorProtocol {

  // MARK: - Error

  func showErrorAlert<T>(response: ApiResponse<T>?) {

    guard let response = response else {

      LoadingIndicator.hideLoading()

      self.showAlertView(
        message: "네트워크 연결을 확인해 주세요.",
        confirmAction: nil
      )
      return
    }

    guard response.data != nil else {

      LoadingIndicator.hideLoading()

      self.showAlertView(
        message: response.message,
        confirmAction: nil
      )
      return
    }
  }
}
