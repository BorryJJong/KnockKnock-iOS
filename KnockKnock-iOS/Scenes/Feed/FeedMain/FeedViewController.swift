//
//  FeedListVIew.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

protocol FeedViewProtocol: AnyObject {
  var interactor: FeedInteractorProtocol? { get set }

  func getFeedMain(feed: FeedMain)
  func getChallengeTitles(challengeTitle: [ChallengeTitle], index: IndexPath?)
}

final class FeedViewController: BaseViewController<FeedView> {

  // MARK: - Enums

  private enum CollectionViewTag: Int {
    case tag = 0
    case feed = 1

    static let allCases: [CollectionViewTag] = [.tag, .feed]
  }

  // MARK: - Properties

  var interactor: FeedInteractorProtocol?
  var router: FeedRouterProtocol?

  var feedMain: FeedMain? {
    didSet {
      self.containerView.feedCollectionView.reloadData()
    }
  }
  var challengeTitles: [ChallengeTitle] = []

  var currentPage = 1
  let pageSize = 21
  var challengeId = 0

  // MARK: - Lify Cycles

  override func viewDidLoad() {
    super.viewDidLoad()

    self.extendedLayoutIncludesOpaqueBars = true
    self.navigationItem.hidesSearchBarWhenScrolling = false

    self.interactor?.getFeedMain(
      currentPage: self.currentPage,
      pageSize: self.pageSize,
      challengeId: self.challengeId
    )
    self.interactor?.getChallengeTitles()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.navigationItem.searchController = containerView.searchBar

    self.containerView.tagCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TagCell.self)
      $0.collectionViewLayout = self.containerView.tagCollectionViewLayout()
      $0.tag = CollectionViewTag.tag.rawValue
    }

    self.containerView.feedCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: FeedCell.self)
      $0.collectionViewLayout = self.containerView.feedCollectionViewLayout()
      $0.tag = CollectionViewTag.feed.rawValue
    }
  }

  // MARK: - Button Actions

  @objc func didTapViewMoreButton(_ sender: UIButton) {
    self.currentPage += 1
    self.interactor?.getFeedMain(
      currentPage: self.currentPage,
      pageSize: self.pageSize,
      challengeId: self.challengeId
    )
  }
}

// MARK: - Extensions

extension FeedViewController: FeedViewProtocol {
  func getFeedMain(feed: FeedMain) {
    self.feedMain = feed
    self.containerView.feedCollectionView.reloadData()
  }

  func getChallengeTitles(
    challengeTitle: [ChallengeTitle],
    index: IndexPath?
  ) {
    self.challengeTitles = challengeTitle

    if let index = index {
      UIView.performWithoutAnimation {
        self.containerView.tagCollectionView.reloadSections([0])
        self.containerView.tagCollectionView.scrollToItem(
          at: index,
          at: .centeredHorizontally,
          animated: false)
      }
    } else {
      self.containerView.tagCollectionView.reloadData()
    }
  }
}

extension FeedViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch collectionView.tag {
    case CollectionViewTag.tag.rawValue:
      return self.challengeTitles.count

    case CollectionViewTag.feed.rawValue:
      return self.feedMain?.total ?? 0
      
    default:
      return 0
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch collectionView.tag {
    case CollectionViewTag.tag.rawValue:
      let cell = collectionView.dequeueCell(
        withType: TagCell.self,
        for: indexPath
      )
      cell.bind(tag: self.challengeTitles[indexPath.item])

      if indexPath.item == 0 {
        cell.isSelected = true
        collectionView.selectItem(
          at: indexPath,
          animated: false,
          scrollPosition: .init()
        )
      }

      return cell

    case CollectionViewTag.feed.rawValue:
      let cell = collectionView.dequeueCell(
        withType: FeedCell.self,
        for: indexPath
      )
      if let feed = self.feedMain {
        cell.bind(post: feed.feeds[indexPath.item])
      }
      return cell

    default:
      return UICollectionViewCell()
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryFooterView(
      withType: FooterCollectionReusableView.self,
      for: indexPath
    )
    if let feedMain = self.feedMain {
      if !feedMain.isNext {
        footer.viewMoreButton.isHidden = true
      } else {
        footer.viewMoreButton.isHidden = false
      }
    }

    footer.viewMoreButton.addTarget(
      self,
      action: #selector(self.didTapViewMoreButton(_:)),
      for: .touchUpInside
    )
    return footer
  }
}

extension FeedViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    switch collectionView.tag {
    case CollectionViewTag.tag.rawValue:
      self.interactor?.setSelectedStatus(
        challengeTitles: challengeTitles,
        selectedIndex: indexPath
      )

      self.challengeId = indexPath.item
      self.currentPage = 1

      self.interactor?.getFeedMain(
        currentPage: self.currentPage,
        pageSize: self.pageSize,
        challengeId: self.challengeId
      )

    case CollectionViewTag.feed.rawValue:
      self.router?.navigateToFeedList(source: self)

    default:
      return
    }
  }
}
