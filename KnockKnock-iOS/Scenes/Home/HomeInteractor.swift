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

  func fetchInitialData()

  func fetchHotpost(challengeId: Int)
  func fetchChallengeList()
  func setSelectedStatus(
    challengeList: [ChallengeTitle],
    selectedIndex: IndexPath
  )
  func fetchEventList()
  func fetchBanner(bannerType: BannerType)
  func fetchVerifiedStore()

  func navigateToStoreListView()
  func navigateToEventPageView()
  func navigateToFeedDetail(feedId: Int)
  func navigateToFeedWrite()
  func navigateToChallengeDetail(challengeId: Int?)
}

final class HomeInteractor: HomeInteractorProtocol {

  // MARK: - Properties

  var presenter: HomePresenterProtocol?
  var worker: HomeWorkerProtocol?
  var router: HomeRouterProtocol?

  var hotPostList: [HotPost] = []
  private var challengeId = 0

  // MARK: - Initialize

  init() {
    self.setNotification()
  }

  // Buisiness logic

  func fetchInitialData() {
    self.fetchBanner(bannerType: .main)
    self.fetchBanner(bannerType: .bar)
    self.fetchVerifiedStore()
    self.fetchHotpost(challengeId: 0)
    self.fetchChallengeList()
    self.fetchEventList()
  }

  func fetchHotpost(challengeId: Int) {

    self.worker?.fetchHotPostList(
      challengeId: challengeId,
      completionHandler: { [weak self] response in

        guard let self = self else { return }

        self.showErrorAlert(response: response)

        guard let hotPostList = response?.data else { return }

        self.hotPostList = hotPostList
        self.presenter?.presentHotPostList(hotPostList: hotPostList)
      }
    )
  }

  // 챌린지 목록 패치(최초 실행시)
  func fetchChallengeList() {
    self.worker?.fetchChallengeList { [weak self] response in

      guard let self = self else { return }

      self.showErrorAlert(response: response)

      guard var challenges = response?.data else { return }

      challenges[0].isSelected = true

      self.presenter?.presentChallengeList(
        challengeList: challenges,
        index: nil
      )
    }
  }

  func fetchEventList() {

    Task {
      let response = await self.worker?.fetchEventList()

      await MainActor.run {
        self.showErrorAlert(response: response)
      }

      guard let eventList = response?.data else { return }

      self.presenter?.presentEventList(eventList: eventList)
    }
  }

  /// 배너 데이터 조회
  func fetchBanner(bannerType: BannerType) {

    Task {
      let response = await self.worker?.fetchBanner(bannerType: bannerType)

      await MainActor.run {
        self.showErrorAlert(response: response)
      }

      guard let bannerList = response?.data else { return }

      switch bannerType {

      case .main:
        self.presenter?.presentMainBannerList(bannerList: bannerList)
        
      case .bar:
        self.presenter?.presentBarBannerList(bannerList: bannerList)
      }

    }
  }

  func fetchVerifiedStore() {

    Task {
      let response = await self.worker?.fetchVerifiedStore()

      await MainActor.run {
        self.showErrorAlert(response: response)
      }
      guard let storeList = response?.data else { return }

      self.presenter?.presentStoreList(storeList: storeList)
    }
  }

  func setSelectedStatus(
    challengeList: [ChallengeTitle],
    selectedIndex: IndexPath
  ) {
    var challenges = challengeList

    self.challengeId = challenges[selectedIndex.item].id

    for index in 0..<challenges.count {
        challenges[index].isSelected = index == selectedIndex.item
    }

    presenter?.presentChallengeList(
      challengeList: challenges,
      index: selectedIndex
    )
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

  func navigateToFeedWrite() {
    self.router?.navigateToFeedWrite()
  }

  func navigateToChallengeDetail(challengeId: Int?) {
    guard let challengeId = challengeId else { return }
    self.router?.navigateToChallengeDetail(challengeId: challengeId)
  }
}

extension HomeInteractor {

  // MARK: - Error

  private func showErrorAlert<T>(response: ApiResponse<T>?) {

    guard let response = response else {

      LoadingIndicator.hideLoading()

      self.presenter?.presentAlert(
        message: AlertMessage.unknownedError.rawValue,
        isCancelActive: false,
        confirmAction: nil
      )

      return
    }

    guard response.data != nil else {

      LoadingIndicator.hideLoading()

      self.presenter?.presentAlert(
        message: response.message,
        isCancelActive: false,
        confirmAction: nil
      )
      return
    }
  }

  // MARK: - NotificationCenter

  private func setNotification() {
    NotificationCenter.default.addObserver(
      forName: .homePopularPostRefresh,
      object: nil,
      queue: nil
    ) { _ in
      self.fetchHotpost(challengeId: self.challengeId)
    }
  }
}
