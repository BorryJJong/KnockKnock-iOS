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

  // MARK: - Properties

  private let taps: [String] = ["인기", "계정", "태그", "장소"]
  private let colors: [UIColor] = [UIColor.orange, UIColor.blue, UIColor.green, UIColor.black]

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
    self.containerView.searchResultPageCollectionView.do {
      $0.tag = SearchCollectionViewTag.result.rawValue
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: SearchResultPageCell.self)
      $0.isPagingEnabled = true
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
      cell.bind(tapName: self.taps[indexPath.item])

      return cell

    case .result:
      let cell = collectionView.dequeueCell(withType: SearchResultPageCell.self, for: indexPath)
      cell.backgroundColor = colors[indexPath.item]

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
    let collectionViewTag = SearchCollectionViewTag(rawValue: collectionView.tag)

    switch collectionViewTag {
    case .tap:
      return CGSize(
        width: 25,
        height: 40
      )

    case .result:
      return CGSize(
        width: self.containerView.frame.width,
        height: self.containerView.searchResultPageCollectionView.frame.height
      )

    default:
      assert(false)
    }
  }
}
