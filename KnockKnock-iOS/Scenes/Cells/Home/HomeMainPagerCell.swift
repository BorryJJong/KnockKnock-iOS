//
//  HomeMainPagerCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/07.
//

import UIKit

import SnapKit
import KKDSKit
import Then

class HomeMainPagerCell: BaseCollectionViewCell {

  // MARK: - Properties

  var mainImages: [String] = ["", "", ""]
  var page: Int?

  // MARK: - UIs

  let homeMainCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
    }).then {
      $0.contentInsetAdjustmentBehavior = .never
      $0.alwaysBounceVertical = false
    }

  let pageControl = UIPageControl().then {
    $0.currentPage = 0
    $0.hidesForSinglePage = true
    $0.preferredIndicatorImage = KKDS.Image.ic_page_10_wh_off
    $0.backgroundStyle = .minimal
  }

  override func setupCollectionView() {
    self.homeMainCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: HomeMainCell.self)
      $0.collectionViewLayout = self.setHomeMainPagerCollectionViewLayout()
    }
    self.pageControl.do {
      $0.numberOfPages = self.mainImages.count
      $0.setIndicatorImage(KKDS.Image.ic_page_10_wh_on, forPage: $0.currentPage)
    }
  }

  override func setupConstraints() {
    [self.homeMainCollectionView, self.pageControl].addSubViews(self.contentView)

    self.homeMainCollectionView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }

    self.pageControl.snp.makeConstraints {
      $0.bottom.leading.equalTo(self.contentView).inset(20)
    }
  }

  func setHomeMainPagerCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let mainItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1)
    )
    let mainItem = NSCollectionLayoutItem(layoutSize: mainItemSize)

    let mainGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1)
    )
    let mainGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: mainGroupSize,
      subitems: [mainItem]
    )

    let mainSection = NSCollectionLayoutSection(group: mainGroup)
    mainSection.orthogonalScrollingBehavior = .paging

    let layout = UICollectionViewCompositionalLayout(section: mainSection)

    return layout
  }

}

extension HomeMainPagerCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.mainImages.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: HomeMainCell.self, for: indexPath)

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    self.page = indexPath.item
  }

  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == self.page {
      page = nil
    }

    if indexPath.item == self.pageControl.currentPage {
      if let page = self.page {
        self.pageControl.currentPage = page
      }
    }
  }
}
