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
      guard let result = await self.repository?.requestVerifiedStoreDetailList() else {
        return
      }

      self.presenter?.presentStoreList(storeList: result)
    }
  }
}
