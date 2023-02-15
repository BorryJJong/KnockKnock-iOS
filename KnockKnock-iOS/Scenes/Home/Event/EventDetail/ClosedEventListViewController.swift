//
//  ClosedEventListViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/19.
//

import UIKit

final class ClosedEventListViewController: BaseViewController<EventListView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.eventCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: EventCell.self)
    }
  }
}

// MARK: - CollectionView DataSource, Delegate

extension ClosedEventListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 5
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: EventCell.self,
      for: indexPath
    )
    cell.isClosedEvent(isClosed: true)
    
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    let width = self.containerView.frame.width - 40

    return CGSize(
      width: width,
      height: width/2
    )
  }
}
