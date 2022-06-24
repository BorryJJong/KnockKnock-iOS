//
//  FeedListViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

import Then

class FeedListViewController: BaseViewController<FeedListView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
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
    return 10
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: FeedListCell.self, for: indexPath)
    cell.bind()
    DispatchQueue.main.async {
      cell.contentLabel.addTrailing(with: "...", moreText: "더보기", moreTextFont: UIFont.systemFont(ofSize: 13, weight: .medium), moreTextColor: UIColor.gray)
    }
    return cell
  }
}

extension FeedListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: (self.containerView.frame.width - 40),
      height: ((self.containerView.frame.width - 40) + 200))
  }
}
