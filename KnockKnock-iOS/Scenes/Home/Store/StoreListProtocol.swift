//
//  StoreListProtocol.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/25.
//

import UIKit

protocol StoreListViewProtocol: AnyObject {
  var interactor: StoreListInteractorProtocol? { get set }

  func fetchStoreList(storeList: [StoreDetail])

  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

protocol StoreListInteractorProtocol {
  var router: StoreListRouterProtocol? { get set }
  var presenter: StoreListPresentorProtocol? { get set }

  func fetchStoreDetailList()
}

protocol StoreListPresentorProtocol {
  var view: StoreListViewProtocol? { get set }

  func presentStoreList(storeList: [StoreDetail])
  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

protocol StoreListRouterProtocol {
  var view: StoreListViewProtocol? { get set }

  static func createStoreListView() -> UIViewController
}
