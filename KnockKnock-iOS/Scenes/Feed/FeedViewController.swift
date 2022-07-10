//
//  FeedListVIew.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

protocol FeedViewProtocol: AnyObject {
  var interactor: FeedInteractorProtocol? { get set }

  func fetchFeed(feed: [Feed])
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
  var router = FeedRouter()

  var feed: [Feed] = []
  var challengeTitles: [ChallengeTitle] = []

  // MARK: - Lify Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.extendedLayoutIncludesOpaqueBars = true
    self.interactor?.fetchFeed()
    self.interactor?.getChallengeTitles()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

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
}

// MARK: - Extensions

extension FeedViewController: FeedViewProtocol {
  func fetchFeed(feed: [Feed]) {
    self.feed = feed
    self.containerView.feedCollectionView.reloadData()
  }

  func getChallengeTitles(challengeTitle: [ChallengeTitle], index: IndexPath?) {
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
      return self.feed.count
      
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
      let cell = collectionView.dequeueCell(withType: TagCell.self, for: indexPath)
      cell.bind(tag: self.challengeTitles[indexPath.item])

      if indexPath.item == 0 {
        cell.isSelected = true
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
      }

      return cell

    case CollectionViewTag.feed.rawValue:
      let cell = collectionView.dequeueCell(withType: FeedCell.self, for: indexPath)
      let feed = self.feed[indexPath.item]
      cell.bind(feed: feed)
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
    let footer = collectionView.dequeueReusableSupplementaryFooterView(for: indexPath)
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

    case CollectionViewTag.feed.rawValue:
      self.router.navigateToFeedList(
        source: self,
        destination: FeedListRouter.createFeedList() as! FeedListViewController
      )

    default:
      return
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didDeselectItemAt indexPath: IndexPath
  ) {
    self.interactor?.setSelectedStatus(
      challengeTitles: challengeTitles,
      selectedIndex: indexPath
    )
  }
}
