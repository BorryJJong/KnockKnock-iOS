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
}

extension StoreListInteractorProtocol {

  // MARK: - Error

  func showErrorAlert<T>(response: ApiResponse<T>?) {
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
