//
//  ShopSearchInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/27.
//

import UIKit

protocol ShopSearchInteractorProtocol {
  var worker: ShopSearchWorkerProtocol? { get set }
  var presenter: ShopSearchPresenterProtocol? { get set }

  func fetchShopAddress(keyword: String, page: Int)

}

final class ShopSearchInteractor: ShopSearchInteractorProtocol {

  var worker: ShopSearchWorkerProtocol?
  var presenter: ShopSearchPresenterProtocol?

  func fetchShopAddress(keyword: String, page: Int) {
    self.worker?.fetchShopAddress(
      keyword: keyword,
      page: page,
      completionHandler: { address in
        self.presenter?.presentShopAddress(address: address)
      })
  }
}
