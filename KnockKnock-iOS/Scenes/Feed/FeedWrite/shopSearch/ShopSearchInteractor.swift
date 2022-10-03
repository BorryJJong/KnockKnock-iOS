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

  func fetchShopAddress(keyword: String)

}

final class ShopSearchInteractor: ShopSearchInteractorProtocol {

  var worker: ShopSearchWorkerProtocol?
  var presenter: ShopSearchPresenterProtocol?

  func fetchShopAddress(keyword: String) {
    self.worker?.fetchShopAddress(
      keyword: keyword,
      completionHandler: { address in
        self.presenter?.presentShopAddress(address: address)
      })
  }
}
