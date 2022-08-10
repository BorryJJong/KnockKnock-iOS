//
//  LikeDetailViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/10.
//

import UIKit

import SnapKit
import Then

class LikeDetailViewContoller: BaseViewController<LikeDetailView> {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupConfigure() {
    self.containerView.likeCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: LikeDetailCell.self)
    }
  }
}

extension LikeDetailViewContoller: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView
    , numberOfItemsInSection section: Int
  ) -> Int {
    return 10
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: LikeDetailCell.self,
      for: indexPath
    )

    return cell
  }
}
