//
//  StoreListPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/25.
//

import Foundation

final class StoreListPresenter: StoreListPresentorProtocol {

  weak var view: StoreListViewProtocol?

  func presentStoreList(storeList: [StoreDetail]) {

    self.view?.fetchStoreList(storeList: storeList)

  }

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  ) {
    self.view?.showAlertView(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}
