//
//  EventListViewContoller.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/12.
//

import UIKit

import Then

final class EventPageViewController: BaseViewController<EventPageView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  override func setupConfigure() {
    self.containerView.tapCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TapCell.self)
    }
  }
}

// MARK: - CollectionView Delegate, DataSource

extension EventPageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: TapCell.self, for: indexPath)

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 70, height: 40)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
}
