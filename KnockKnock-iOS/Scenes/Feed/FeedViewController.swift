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
}

final class FeedViewController: BaseViewController<FeedView> {

  // MARK: - Properties

  var interactor: FeedInteractorProtocol?
  var router = FeedRouter()
  var feed: [Feed] = []

  private let tagList = ["전체", "#친환경", "#제로웨이스트", "#용기내챌린지", "#업사이클링" ]

  // MARK: - Lify Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.fetchFeed()
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
}

extension FeedViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch section {
    case 0:
      return self.tagList.count

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
      cell.backgroundColor = .white
      cell.tagLabel.text = self.tagList[indexPath.item]
      return cell

    case 1:
      let cell = collectionView.dequeueCell(withType: FeedCell.self, for: indexPath)
      let feed = self.feed[indexPath.item]
      cell.backgroundColor = .white
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      if let cell = collectionView.cellForItem(at: indexPath) as? TagCell {
        cell.tagLabel.backgroundColor = .green50
        cell.tagLabel.textColor = .white
        cell.tagLabel.font = .systemFont(ofSize: 16, weight: .bold)
      }

    case 1:
      self.router.navigateToFeedList(source: self, destination: FeedListRouter.createFeedList() as! FeedListViewController)

    default:
      return
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      if let cell = collectionView.cellForItem(at: indexPath) as? TagCell {
        cell.tagLabel.backgroundColor = .white
        cell.tagLabel.textColor = .green50
        cell.tagLabel.font = .systemFont(ofSize: 16, weight: .medium)
      }
    }
  }
}
