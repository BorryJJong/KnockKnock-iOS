//
//  EventListViewContoller.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/12.
//

import UIKit

import Then

final class EventListViewController: BaseViewController<EventListView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupConfigure() {
    self.containerView.tapCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
    }
  }
}

// MARK: - CollectionView Delegate, DataSource

extension EventListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: TapCell.self, for: indexPath)
    return cell
  }
}
