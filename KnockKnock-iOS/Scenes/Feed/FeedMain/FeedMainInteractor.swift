//
//  FeedInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import Foundation

protocol FeedMainInteractorProtocol {
  var presenter: FeedMainPresenterProtocol? { get set }
  var worker: FeedMainWorkerProtocol? { get set }
  var router: FeedMainRouterProtocol? { get set }

  func fetchFeedMain(
    currentPage: Int,
    pageSize: Int,
    challengeId: Int
  )
  func fetchChallengeTitles()
  func setSelectedStatus(
    challengeTitles: [ChallengeTitle],
    selectedIndex: IndexPath
  )

  func saveSearchKeyword(searchKeyword: [SearchKeyword])

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  )
  func navigateToFeedList(
    feedId: Int,
    challengeId: Int
  )
}

final class FeedMainInteractor: FeedMainInteractorProtocol {

  // MARK: - Properties
  
  var presenter: FeedMainPresenterProtocol?
  var worker: FeedMainWorkerProtocol?
  var router: FeedMainRouterProtocol?

  private var feedData: FeedMain?

  // MARK: - Initialize

  init() {
    self.setNotification()
  }

  // MARK: - Business Logic

  func saveSearchKeyword(searchKeyword: [SearchKeyword]) {
    self.worker?.saveSearchKeyword(searchKeyword: searchKeyword)
  }

  func fetchFeedMain(
    currentPage: Int,
    pageSize: Int,
    challengeId: Int
  ) {
    LoadingIndicator.showLoading()
    
    self.worker?.fetchFeedMain(
      currentPage: currentPage,
      pageSize: pageSize,
      challengeId: challengeId,
      completionHandler: { [weak self] result in

        guard let self = self else { return }

        switch result {

        case .success(let response):

          guard let data = response.data,
                response.code == 200 else {

            LoadingIndicator.hideLoading()

            self.showAlertView(
              message: response.message,
              confirmAction: nil
            )
            return
          }

          if currentPage == 1 {
            self.feedData = data
          } else {
            self.feedData?.feeds += data.feeds
            self.feedData?.isNext = data.isNext
          }

          guard let feedData = self.feedData else { return }
          self.presenter?.presentFeedMain(feed: feedData)

        case .failure(let err):

          LoadingIndicator.hideLoading()

          self.showAlertView(
            message: err.message,
            confirmAction: nil
          )
        }
      }
    )
  }

  func fetchChallengeTitles() {

    self.worker?.fetchChallengeTitles { [weak self] result in

      guard let self = self else { return }

      switch result {
      case .success(let response):

        guard var challengeTitle = response.data,
              response.code == 200 else {

          LoadingIndicator.hideLoading()

          self.showAlertView(
            message: response.message,
            confirmAction: nil
          )

          return
        }

        challengeTitle[0].isSelected = true

        self.presenter?.presentGetChallengeTitles(
          challengeTitle: challengeTitle,
          index: nil
        )

      case .failure(let err):
        
        LoadingIndicator.hideLoading()

        self.showAlertView(
          message: err.message,
          confirmAction: nil
        )
      }
    }
  }

  func setSelectedStatus(
    challengeTitles: [ChallengeTitle],
    selectedIndex: IndexPath
  ) {
    var challengeTitles = challengeTitles

    for index in 0..<challengeTitles.count {

      if index == selectedIndex.item {
        challengeTitles[index].isSelected = true

      } else {
        challengeTitles[index].isSelected = false
      }
    }
    presenter?.presentGetChallengeTitles(
      challengeTitle: challengeTitles,
      index: selectedIndex
    )
  }

  // MARK: - Routing

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    self.router?.showAlertView(
      message: message,
      confirmAction: confirmAction
    )
  }

  func navigateToFeedList(
    feedId: Int,
    challengeId: Int
  ) {
    self.router?.navigateToFeedList(
      feedId: feedId,
      challengeId: challengeId
    )
  }
}

extension FeedMainInteractor {

  /// 피드 상세에서 발생한 삭제 이벤트 반영
  @objc
  private func deleteNotificationEvent(_ notification: Notification) {
    guard let feedId = notification.object as? Int else { return }

    guard let feedData = self.feedData else { return }
    guard !feedData.feeds.isEmpty else { return }

    // 삭제 요청한 피드의 index
    guard let index = self.feedData?.feeds.firstIndex(where: { feedId == $0.id }) else { return }

    self.feedData?.feeds.remove(at: index)

    guard let feedData = self.feedData else { return }
    self.presenter?.presentFeedMain(feed: feedData)
  }

  // MARK: - Notification Center

  private func setNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.deleteNotificationEvent(_:)),
      name: .feedMainRefreshAfterDelete,
      object: nil
    )

    NotificationCenter.default.addObserver(
      forName: .feedMainRefreshAfterWrite,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.reloadFeedMain()
    }
  }
}
