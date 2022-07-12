//
//  FeedListViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

import Then

protocol FeedListViewProtocol: AnyObject {
  var interactor: FeedListInteractorProtocol? { get set }

  func fetchFeedList(feed: [Feed])
}

final class FeedListViewController: BaseViewController<FeedListView> {

  // MARK: - Constants

  private enum Scale {
    static let square = "1:1"
    static let threeToFour = "3:4"
    static let fourToThree = "4:3"
  }

  // MARK: - Properties

  var interactor: FeedListInteractorProtocol?
  var feed: [Feed] = []

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactor?.fetchFeed()
  }

  override func setupConfigure() {
    self.containerView.feedListCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: FeedListCell.self)
    }
  }
}

// MARK: - Extensions

extension FeedListViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.feed.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: FeedListCell.self, for: indexPath)
    cell.bind(feed: self.feed[indexPath.item])
    return cell
  }
}

extension FeedListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    let scale = feed[indexPath.item].scale
    let scaleType = ImageScaleType(rawValue: scale)
    
    return scaleType?.cellSize(width: self.containerView.frame.width) ?? CGSize.init()
  }
}

extension FeedListViewController: FeedListViewProtocol {
  func fetchFeedList(feed: [Feed]) {
    self.feed = feed
  }
}
