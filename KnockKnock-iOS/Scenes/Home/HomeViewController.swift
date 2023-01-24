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
}

final class HomeViewController: BaseViewController<HomeView> {

  // MARK: - Properties

  var interactor: HomeInteractorProtocol?

  var hotPostList: [HotPost] = [] {
    didSet {
      UIView.performWithoutAnimation {
        self.containerView.homeCollectionView.reloadSections(
          IndexSet(integer: HomeSection.popularPost.rawValue)
        )
      }
    }
  }

  var challengeList: [ChallengeTitle] = []
  private var challengeId: Int = 0

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
    self.interactor?.fetchHotpost(challengeId: self.challengeId)
    self.interactor?.fetchChallengeList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.changeStatusBarBgColor(bgColor: .clear)
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
  func fetchHotPostList(hotPostList: [HotPost]) {
    self.hotPostList = hotPostList
  }

  func fetchChallengeList(
    challengeList: [ChallengeTitle],
    index: IndexPath?
  ) {
    self.challengeList = challengeList
    if let index = index {
      UIView.performWithoutAnimation {
        self.containerView.homeCollectionView.reloadSections([HomeSection.tag.rawValue])
        self.containerView.homeCollectionView.scrollToItem(
          at: index,
          at: .centeredHorizontally,
          animated: false
        )
      }
    } else {
      self.containerView.homeCollectionView.reloadSections([HomeSection.tag.rawValue])
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

    case .event, .banner, .store:
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
