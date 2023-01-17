//
//  HomeInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/23.
//

import UIKit

protocol HomeInteractorProtocol {
  var presenter: HomePresenterProtocol? { get set }
  var worker: HomeWorkerProtocol? { get set }
  var router: HomeRouterProtocol? { get set }

  func navigateToStoreListView()
  func navigateToEventPageView()
}

final class HomeInteractor: HomeInteractorProtocol {

  // MARK: - Properties

  var presenter: HomePresenterProtocol?
  var worker: HomeWorkerProtocol?
  var router: HomeRouterProtocol?

  func navigateToStoreListView() {
    self.router?.navigateToStoreListView()
  }

  func navigateToEventPageView() {
    self.router?.navigateToEventPageView()
  }
}
