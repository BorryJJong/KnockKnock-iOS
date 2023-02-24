//
//  HomePresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/23.
//

import Foundation

protocol HomePresenterProtocol {
  var view: HomeViewProtocol? { get set }

  func presentEventList(eventList: [Event])
  func presentHotPostList(hotPostList: [HotPost])
  func presentChallengeList(
    challengeList: [ChallengeTitle],
    index: IndexPath?
  )
  func presentMainBannerList(bannerList: [HomeBanner])
  func presentBarBannerList(bannerList: [HomeBanner])
}

final class HomePresenter: HomePresenterProtocol {
  weak var view: HomeViewProtocol?

  func presentHotPostList(hotPostList: [HotPost]) {
    self.view?.fetchHotPostList(hotPostList: hotPostList)
  }

  func presentChallengeList(challengeList: [ChallengeTitle], index: IndexPath?) {
    self.view?.fetchChallengeList(challengeList: challengeList, index: index)
  }

  func presentEventList(eventList: [Event]) {
    self.view?.fetchEventList(eventList: eventList)
  }

  func presentMainBannerList(bannerList: [HomeBanner]) {
    self.view?.fetchMainBannerList(bannerList: bannerList)
  }

  func presentBarBannerList(bannerList: [HomeBanner]) {
    self.view?.fetchBarBannerList(bannerList: bannerList)
  }
}
