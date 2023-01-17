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

  func fetchHotpost(challengeId: Int)

  func navigateToStoreListView()
  func navigateToEventPageView()
}

final class HomeInteractor: HomeInteractorProtocol {

  // MARK: - Properties

  var presenter: HomePresenterProtocol?
  var worker: HomeWorkerProtocol?
  var router: HomeRouterProtocol?

  var hotPostList: [HotPost] = []

  // Buisiness logic

  func fetchHotpost(challengeId: Int) {
    self.worker?.fetchHotPostList(completionHandler: { [weak self] hotPostList in
      self?.hotPostList = hotPostList
      self?.presenter?.presentHotPostList(hotPostList: hotPostList)
    })
  }

  // Routing

  func navigateToStoreListView() {
    self.router?.navigateToStoreListView()
  }

  func navigateToEventPageView() {
    self.router?.navigateToEventPageView()
  }
}
