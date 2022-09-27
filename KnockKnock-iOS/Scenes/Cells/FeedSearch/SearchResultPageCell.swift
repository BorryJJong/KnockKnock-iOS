//
//  SearchResultPageCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/30.
//

import UIKit

import Then
import SnapKit

final class SearchResultPageCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let searchResultCollectionViewLadingMargin = 20.f
  }

  // MARK: - Properties

  private var tapIndex = 0 {
    didSet {
      self.searchResultCollectionView.reloadData()
    }
  }

  // MARK: - UIs

  let searchResultCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    }
  )

  // MARK: - Bind

  func bind(index: IndexPath) {
    self.tapIndex = index.row
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.searchResultCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: SearchResultCell.self)
      $0.registHeaderView(type: FeedSearchResultHeaderReusableView.self)
      $0.registFooterView(type: FeedSearchResultFooterReusableView.self)
    }
  }

  override func setupConstraints() {
    [self.searchResultCollectionView].addSubViews(self.contentView)

    self.searchResultCollectionView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(Metric.searchResultCollectionViewLadingMargin)
    }
  }
}

// MARK: - CollectionView DataSource, Delegate

extension SearchResultPageCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 3
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if self.tapIndex == 0 {
      return 2
    } else {
      return 1
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(
      withType: SearchResultCell.self,
      for: indexPath
    )
    cell.backgroundColor = .white
    if indexPath.section == 0 && self.tapIndex == 0 {
      cell.bind(tap: SearchTap.allCases[self.tapIndex], isLogSection: false)
    } else {
      cell.bind(tap: SearchTap.allCases[self.tapIndex], isLogSection: true)
    }
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: self.frame.width,
      height: 62
    )
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {

    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let header = collectionView.dequeueReusableSupplementaryHeaderView(
        withType: FeedSearchResultHeaderReusableView.self,
        for: indexPath
      )
    
      return header

    case UICollectionView.elementKindSectionFooter:
      let footer = collectionView.dequeueReusableSupplementaryFooterView(
        withType: FeedSearchResultFooterReusableView.self,
        for: indexPath
      )

      if indexPath.section == 0 && self.tapIndex == 0 {
        footer.isHidden = false
      } else {
        footer.isHidden = true
      }

      return footer

    default:
      assert(false)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    var headerSize = CGSize(
      width: self.frame.width,
      height: 25
    )
    if section == 0 && self.tapIndex == 0 {
      headerSize.height = 0
    }

    return headerSize
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    return CGSize(
      width: self.frame.width,
      height: 26
    )
  }
}
