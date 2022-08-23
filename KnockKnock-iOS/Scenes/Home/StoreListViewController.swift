//
//  StoreListViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/22.
//

import UIKit

final class StoreListViewController: BaseViewController<StoreListView> {

  // MARK: - Properties

  private let store = ["", "", "", ""]

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  override func setupConfigure() {
    self.containerView.storeCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: StoreListCell.self)
    }
  }
}

extension StoreListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.store.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: StoreListCell.self,
      for: indexPath
    )
    let isLast = indexPath.item == (self.store.count - 1)
    cell.setSeparatorLineView(isLast: isLast)

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: self.containerView.frame.width - 40,
      height: 95
    )
  }
}
