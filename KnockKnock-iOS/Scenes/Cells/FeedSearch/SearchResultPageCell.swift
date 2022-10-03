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

  var searchKeyword: [SearchTap: [SearchKeyword]] = [:] {
    didSet{
      if let allKeywords = searchKeyword[SearchTap.popular] {
        self.allKeywords = allKeywords
      }
      if let tagKeywords = searchKeyword[SearchTap.tag] {
        self.tagKeywords = tagKeywords
      }
      if let accountKeywords = searchKeyword[SearchTap.account] {
        self.accountKeywords = accountKeywords
      }
      if let placeKeywords = searchKeyword[SearchTap.place] {
        self.placeKeywords = placeKeywords
      }

      self.searchResultCollectionView.reloadData()
    }
  }

  var allKeywords: [SearchKeyword] = []
  var tagKeywords: [SearchKeyword] = []
  var accountKeywords: [SearchKeyword] = []
  var placeKeywords: [SearchKeyword] = []

  // MARK: - UIs

  let searchResultCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    }
  ).then {
    $0.backgroundColor = .clear
  }

  // MARK: - Bind

  func bind(index: IndexPath, searchKeyword: [SearchTap: [SearchKeyword]]) {
    self.tapIndex = index.row
    self.searchKeyword = searchKeyword
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
    switch tapIndex {
    case 0:
      if section == 0 {
        return 3
      } else {
        return self.allKeywords.count
      }
    case 1:
      return self.accountKeywords.count

    case 2:
      return self.tagKeywords.count

    case 3:
      return self.placeKeywords.count
      
    default:
      return 0
    }
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
    
    switch self.tapIndex {
    case 0:
      if indexPath.section == 0 {
        cell.bind(
          tap: SearchTap.allCases[self.tapIndex],
          isLogSection: false,
          keyword: SearchKeyword(category: "인기", keyword: "용기내챌린지")
        )
      } else {
        cell.bind(
          tap: SearchTap.allCases[self.tapIndex],
          isLogSection: true,
          keyword: self.allKeywords[indexPath.item]
        )
      }
    case 1:
      cell.bind(
        tap: SearchTap.allCases[self.tapIndex],
        isLogSection: true,
        keyword: self.accountKeywords[indexPath.item]
      )
    case 2:
      cell.bind(
        tap: SearchTap.allCases[self.tapIndex],
        isLogSection: true,
        keyword: self.tagKeywords[indexPath.item]
      )
    case 3:
      cell.bind(
        tap: SearchTap.allCases[self.tapIndex],
        isLogSection: true,
        keyword: self.placeKeywords[indexPath.item]
      )
    default:
      break
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

      switch tapIndex {
      case 0:
        header.bind(isEmpty: self.allKeywords.count == 0)
      case 1:
        header.bind(isEmpty: self.accountKeywords.count == 0)
      case 2:
        header.bind(isEmpty: self.tagKeywords.count == 0)
      case 3:
        header.bind(isEmpty: self.placeKeywords.count == 0)
      default:
        print("error")
      }
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
