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

  // MARK: - Properties

  var interactor: FeedInteractorProtocol?
  var router = FeedRouter()

  var feed: [Feed] = []
  var challengeTitles: [ChallengeTitle] = []
  var cellWidths: NSMutableDictionary = [:]

  // MARK: - Lify Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.fetchFeed()
    self.interactor?.getChallengeTitles()
  }

  override func setupConfigure() {
    self.navigationItem.searchController = containerView.searchBar

    self.containerView.feedCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TagCell.self)
      $0.registCell(type: FeedCell.self)
      $0.collectionViewLayout = self.containerView.feedCollectionViewLayout()
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
        self.containerView.feedCollectionView.reloadSections([0])
        self.containerView.feedCollectionView.scrollToItem(
          at: index,
          at: .centeredHorizontally,
          animated: false)
      }
    } else {
      self.containerView.feedCollectionView.reloadData()
    }
  }
}

extension FeedViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch section {
    case 0:
      return self.challengeTitles.count

    case 1:
      return self.feed.count
      
    default:
      return 0
    }
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch indexPath.section {
    case 0:
      let cell = collectionView.dequeueCell(withType: TagCell.self, for: indexPath)
      cell.bind(tag: self.challengeTitles[indexPath.item])

      if indexPath.item == 0 {
        cell.isSelected = true
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
      }

      return cell

    case 1:
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
    switch indexPath.section {
    case 0:
      self.interactor?.setSelectedStatus(
        challengeTitles: challengeTitles,
        selectedIndex: indexPath
      )

    case 1:
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
