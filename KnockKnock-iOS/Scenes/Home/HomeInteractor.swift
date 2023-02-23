//
//  HomeInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/23.
//

import Foundation

protocol HomeInteractorProtocol {
  var presenter: HomePresenterProtocol? { get set }
  var worker: HomeWorkerProtocol? { get set }
  var router: HomeRouterProtocol? { get set }

  func fetchHotpost(challengeId: Int)
  func fetchChallengeList()
  func setSelectedStatus(
    challengeList: [ChallengeTitle],
    selectedIndex: IndexPath
  )
  func fetchEventList()

  func navigateToStoreListView()
  func navigateToEventPageView()
  func navigateToFeedDetail(feedId: Int)
}

final class HomeInteractor: HomeInteractorProtocol {

  // MARK: - Properties

  var presenter: HomePresenterProtocol?
  var worker: HomeWorkerProtocol?
  var router: HomeRouterProtocol?

  var hotPostList: [HotPost] = []

  // Buisiness logic

  func fetchHotpost(challengeId: Int) {
    self.worker?.fetchHotPostList(
      challengeId: challengeId,
      completionHandler: { [weak self] hotPostList in
        self?.hotPostList = hotPostList
        self?.presenter?.presentHotPostList(hotPostList: hotPostList)
      }
    )
  }

  func fetchChallengeList() {
    self.worker?.fetchChallengeList { [weak self] challenges in
      var challenges = challenges
      challenges[0].isSelected = true

      self?.presenter?.presentChallengeList(challengeList: challenges, index: nil)
    }
  }

  func fetchEventList() {
    Task {
      guard let eventList = await self.worker?.fetchEventList() else {
        // error
        return
      }

      self.presenter?.presentEventList(eventList: eventList)
    }
  }

  func setSelectedStatus(challengeList: [ChallengeTitle], selectedIndex: IndexPath) {
    var challenges = challengeList

    for index in 0..<challenges.count {
      if index == selectedIndex.item {
        challenges[index].isSelected = true
      } else {
        challenges[index].isSelected = false
      }
    }
    presenter?.presentChallengeList(challengeList: challenges, index: selectedIndex)
  }

  // Routing

  func navigateToStoreListView() {
    self.router?.navigateToStoreListView()
  }

  func navigateToEventPageView() {
    self.router?.navigateToEventPageView()
  }

  func navigateToFeedDetail(feedId: Int) {
    self.router?.navigateToFeedDetail(feedId: feedId)
  }
}
