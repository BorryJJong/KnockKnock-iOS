//
//  FeedListVIew.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

import Then

class FeedViewController: BaseViewController<FeedView> {

  // MARK: - Properties

  let tagList = ["전체", "#친환경", "#제로웨이스트", "#용기내챌린지", "업사이클링" ]

  // MARK: - Lify Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupConfigure() {
    self.navigationItem.searchController = containerView.searchBar
    self.containerView.tagCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TagCell.self)
    }
    self.containerView.feedCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: FeedCell.self)
    }
  }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    var cellSize = CGSize()
    switch collectionView {
    case self.containerView.tagCollectionView:
      cellSize = CGSize(
        width: 100,
        height: 35)
    case self.containerView.feedCollectionView:
      cellSize = CGSize(
        width: (self.containerView.frame.width - 20) / 3,
        height: (self.containerView.frame.height - 120) / 5)
    default:
      break
    }
    return cellSize
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 5
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 5
  }

}
extension FeedViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch collectionView {
    case self.containerView.tagCollectionView:
      return 5
    case self.containerView.feedCollectionView:
      return 30
    default:
      return 0
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    if collectionView == self.containerView.tagCollectionView {

      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TagCell.reusableIdentifier,
        for: indexPath
      ) as! TagCell

      return cell

    } else {

      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: FeedCell.reusableIdentifier,
        for: indexPath
      ) as! FeedCell

      return cell
    }
  }
}

extension FeedViewController: UICollectionViewDelegate {
}
