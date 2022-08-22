//
//  StoreListViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/22.
//

import UIKit

class StoreListViewController: BaseViewController<StoreListView> {

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
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: StoreListCell.self, for: indexPath)

    return cell
  }
}
