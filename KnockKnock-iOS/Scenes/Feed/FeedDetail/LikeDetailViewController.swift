//
//  LikeDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/10.
//

import UIKit

import SnapKit
import Then

final class LikeDetailViewContoller: BaseViewController<LikeDetailView> {

  // MARK: - Properties

  var like: [LikeInfo] = []

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.likeCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: LikeDetailCell.self)
      $0.collectionViewLayout = self.containerView.likeDetailCollectionViewLayout()
    }
  }
}

// MARK: - CollectionView DataSource, Delegate

extension LikeDetailViewContoller: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.like.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: LikeDetailCell.self,
      for: indexPath
    )

    cell.bind(like: like[indexPath.item])

    return cell
  }
}
