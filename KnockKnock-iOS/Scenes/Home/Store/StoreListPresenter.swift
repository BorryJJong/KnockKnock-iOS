//
//  StoreListPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/25.
//

import Foundation

final class StoreListPresenter {

  weak var view: StoreListViewProtocol?

  func presentStoreList(storeList: [StoreDetail]) {

    self.view?.fetchStoreList(storeList: storeList)

  }
}
