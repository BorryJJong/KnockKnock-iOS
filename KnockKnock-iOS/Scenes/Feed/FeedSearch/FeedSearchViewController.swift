//
//  FeedSearchViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/30.
//

import UIKit

import Then

class FeedSearchViewController: BaseViewController<FeedSearchView> {

  // MARK: - Constants

  private enum SearchCollectionViewTag: Int {
    case tap = 0
    case result = 1
  }

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }

  override func setupConfigure() {
    self.containerView.searchTapCollectionView.do {
      $0.tag = SearchCollectionViewTag.tap.rawValue
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TapCell.self)
    }
    self.containerView.searchResultCollectionView.do {
      $0.tag = SearchCollectionViewTag.result.rawValue
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TapCell.self)
    }
  }
}

extension FeedSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 4
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let collectionViewTag = SearchCollectionViewTag(rawValue: collectionView.tag)

    switch collectionViewTag {
    case .tap:
      let cell = collectionView.dequeueCell(withType: TapCell.self, for: indexPath)

      return cell

    case .result:
      let cell = collectionView.dequeueCell(withType: TapCell.self, for: indexPath)

      return cell

    default:
      assert(false)
    }

  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: 70,
      height: 40
    )
  }
}
