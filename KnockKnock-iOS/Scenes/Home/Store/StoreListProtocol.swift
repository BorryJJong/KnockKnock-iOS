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
}

protocol StoreListInteractorProtocol {
  var router: StoreListRouterProtocol? { get set }
  var presenter: StoreListPresentorProtocol? { get set }

  func fetchStoreDetailList()

  func navigateToFeedWrite()

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
}

protocol StoreListPresentorProtocol {
  var view: StoreListViewProtocol? { get set }

  func presentStoreList(storeList: [StoreDetail])
}

protocol StoreListRouterProtocol {
  var view: StoreListViewProtocol? { get set }

  static func createStoreListView() -> UIViewController

  func navigateToFeedWrite()

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
}
