//
//  HomeViewController.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/02/26.
//

import UIKit

import Then
import KKDSKit

protocol HomeViewProtocol: AnyObject {
  var interactor: HomeInteractorProtocol? { get set }

  func fetchHotPostList(hotPostList: [HotPost])
  func fetchChallengeList(
    challengeList: [ChallengeTitle],
    index: IndexPath?
  )
  func fetchEventList(eventList: [Event])
  func fetchMainBannerList(bannerList: [HomeBanner])
  func fetchBarBannerList(bannerList: [HomeBanner])
}

final class HomeViewController: BaseViewController<HomeView> {

  // MARK: - Properties

  var interactor: HomeInteractorProtocol?

  private var mainBannerList: [HomeBanner] = []
  private var barBannerList: [HomeBanner] = []
  private var hotPostList: [HotPost] = []
  private var eventList: [Event] = []
  private var challengeList: [ChallengeTitle] = []
  private var challengeId: Int = 0

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupConfigure()
    self.fetchData()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.setNavigationItem()
    self.containerView.homeCollectionView.do {
      $0.dataSource = self
      $0.delegate = self

      $0.registHeaderView(type: HomeHeaderCollectionReusableView.self)
      $0.registCell(type: HomeMainPagerCell.self)
      $0.registCell(type: StoreCell.self)
      $0.registCell(type: BannerCell.self)
      $0.registCell(type: TagCell.self)
      $0.registCell(type: PopularPostCell.self)
      $0.registFooterView(type: PopularFooterCollectionReusableView.self)
      $0.registCell(type: EventCell.self)

      $0.collectionViewLayout = self.containerView.mainCollectionViewLayout()
    }
  }

  private func fetchData() {
    self.interactor?.fetchBanner(bannerType: .main)
    self.interactor?.fetchBanner(bannerType: .bar)
    self.interactor?.fetchHotpost(challengeId: self.challengeId)
    self.interactor?.fetchChallengeList()
    self.interactor?.fetchEventList()
  }

  // MARK: - Navigation Bar 설정

  func setNavigationItem() {
    self.navigationItem.backButtonTitle = ""
    self.navigationController?.navigationBar.setDefaultAppearance()
  }

  // MARK: - button action

  @objc func moreButtonDidTap(_ sender: UIButton) {
    let section = HomeSection(rawValue: sender.tag)
    if section == .store {
      self.interactor?.navigateToStoreListView()
    } else if section == .event {
      self.interactor?.navigateToEventPageView()
    }
  }
}

// MARK: - HomeViewProtocol

extension HomeViewController: HomeViewProtocol {

  func fetchMainBannerList(bannerList: [HomeBanner]) {
    self.mainBannerList = bannerList

    DispatchQueue.main.async {
      UIView.performWithoutAnimation {
        self.containerView.homeCollectionView.reloadSections([HomeSection.main.rawValue])
      }
    }
  }

  func fetchBarBannerList(bannerList: [HomeBanner]) {
    self.barBannerList = bannerList

    DispatchQueue.main.async {
      UIView.performWithoutAnimation {
        self.containerView.homeCollectionView.reloadSections([HomeSection.banner.rawValue])
      }
    }
  }

  func fetchHotPostList(hotPostList: [HotPost]) {
    self.hotPostList = hotPostList

    DispatchQueue.main.async {
      UIView.performWithoutAnimation {
        self.containerView.homeCollectionView.reloadSections(
          IndexSet(integer: HomeSection.popularPost.rawValue)
        )
      }
    }
  }

  func fetchChallengeList(
    challengeList: [ChallengeTitle],
    index: IndexPath?
  ) {
    self.challengeList = challengeList

    DispatchQueue.main.async {
      guard let index = index else {
        self.containerView.homeCollectionView.reloadSections([HomeSection.tag.rawValue])
        return
      }

      UIView.performWithoutAnimation {
        self.containerView.homeCollectionView.reloadSections([HomeSection.tag.rawValue])
        self.containerView.homeCollectionView.scrollToItem(
          at: index,
          at: .centeredHorizontally,
          animated: false
        )
      }
    }
  }

  func fetchEventList(eventList: [Event]) {
    self.eventList = eventList

    DispatchQueue.main.async {
      self.containerView.homeCollectionView.reloadSections([HomeSection.event.rawValue])
    }
  }
}

// MARK: - CollectionView DataSource, Delegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    let section = HomeSection(rawValue: section)

    switch section {
    case .main:
      return 1

    case .tag:
      return self.challengeList.count

    case .event:
      return self.eventList.count

    case .banner:
      return self.barBannerList.count

    case .store:
      return 6

    case .popularPost:
      return self.hotPostList.count

    default:
      return 1
    }
  }

  func numberOfSections(
    in collectionView: UICollectionView
  ) -> Int {
    return HomeSection.allCases.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let section = HomeSection(rawValue: indexPath.section)
    let challengeId = self.challengeList[indexPath.item].id

    switch section {
    case .tag:
      self.interactor?.setSelectedStatus(
        challengeList: self.challengeList,
        selectedIndex: indexPath
      )
      self.interactor?.fetchHotpost(challengeId: challengeId)

    case .popularPost:
      self.interactor?.navigateToFeedDetail(feedId: self.hotPostList[indexPath.item].postId)

    default:
      print("error")
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let section = HomeSection(rawValue: indexPath.section)

    switch section {
    case .main, .banner:
      return UICollectionReusableView()

    case .store, .event, .tag:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: HomeHeaderCollectionReusableView.self,
        for: indexPath
      )
      header.bind(section: section)

      header.moreButton.tag = indexPath.section
      header.moreButton.addTarget(
        self,
        action: #selector(moreButtonDidTap(_:)),
        for: .touchUpInside
      )
      
      return header

    case .popularPost:
      let footer = collectionView.dequeueReusableSupplementaryFooterView(
        withType: PopularFooterCollectionReusableView.self,
        for: indexPath
      )

      footer.morePostButton.addAction(
        for: .touchUpInside,
        closure: { _ in
          self.tabBarController?.selectedIndex = Tab.feed.rawValue
        }
      )

      return footer

    default:
      return .init()
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let section = HomeSection(rawValue: indexPath.section)

    switch section {
    case .main:
      let cell = collectionView.dequeueCell(
        withType: HomeMainPagerCell.self,
        for: indexPath
      )
      cell.bind(banner: self.mainBannerList)

      return cell

    case .store:
      let cell = collectionView.dequeueCell(
        withType: StoreCell.self,
        for: indexPath
      )

      return cell

    case .banner:
      let cell = collectionView.dequeueCell(
        withType: BannerCell.self,
        for: indexPath
      )
      cell.bind(banner: self.barBannerList[indexPath.item])

      return cell

    case .tag:
      let cell = collectionView.dequeueCell(
        withType: TagCell.self,
        for: indexPath
      )
      cell.bind(tag: self.challengeList[indexPath.item])

      return cell

    case .popularPost:
      let cell = collectionView.dequeueCell(
        withType: PopularPostCell.self,
        for: indexPath
      )
      cell.bind(data: self.hotPostList[indexPath.item])

      return cell

    case .event:
      let cell = collectionView.dequeueCell(
        withType: EventCell.self,
        for: indexPath
      )

      cell.bind(event: self.eventList[indexPath.item])

      return cell

    default:
      let cell = collectionView.dequeueCell(
        withType: DefaultCollectionViewCell.self,
        for: indexPath
      )

      return cell
    }
  }
}
