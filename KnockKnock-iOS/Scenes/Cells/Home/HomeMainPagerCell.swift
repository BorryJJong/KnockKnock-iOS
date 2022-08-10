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

  // MARK: - Constants

  private enum Metric {
    static let lineBackgroundViewWidth = 245.f
    static let lineBackgroundViewHeight = 2.f

    static let lineBackgroundViewLeadingMargin = 20.f
    static let lineBackgroundViewBottomMargin = -30.f
  }

  // MARK: - Properties

  var mainImages: [String] = ["", "", "", "", "", ""]
  var currentIndex: CGFloat = 0

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

  let lineView = UIView().then {
    $0.backgroundColor = .white
  }

  let lineBackgroundView = UIView().then {
    $0.backgroundColor = UIColor(
      red: 255/255,
      green: 255/255,
      blue: 255/255,
      alpha: 0.3
    )
  }

  override func setupCollectionView() {
    self.homeMainCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: HomeMainCell.self)
      $0.collectionViewLayout = self.setHomeMainPagerCollectionViewLayout()
    }
  }

  override func setupConstraints() {
    [self.homeMainCollectionView, self.lineBackgroundView].addSubViews(self.contentView)
    [self.lineView].addSubViews(self.lineBackgroundView)

    self.homeMainCollectionView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }

    self.lineView.snp.makeConstraints {
      $0.top.bottom.leading.equalToSuperview()
      $0.width.equalTo(Metric.lineBackgroundViewWidth / CGFloat(self.mainImages.count))
    }

    self.lineBackgroundView.snp.makeConstraints {
      $0.leading.equalTo(self.contentView).offset(Metric.lineBackgroundViewLeadingMargin)
      $0.bottom.equalTo(self.contentView).offset(Metric.lineBackgroundViewBottomMargin)
      $0.width.equalTo(Metric.lineBackgroundViewWidth)
      $0.height.equalTo(Metric.lineBackgroundViewHeight)
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

    mainSection.visibleItemsInvalidationHandler = ({ (visibleItems, point, env) in
      self.currentIndex = round(point.x / UIScreen.main.bounds.width)
      self.movePager(currentPage: self.currentIndex, itemCount: self.mainImages.count)
    })

    let layout = UICollectionViewCompositionalLayout(section: mainSection)

    return layout
  }

  func movePager(currentPage: CGFloat, itemCount: Int) {
    UIView.animate(withDuration: 0.5, animations: {
      let itemCount = CGFloat(itemCount)
      self.lineView.transform = CGAffineTransform(
        translationX: CGFloat(Metric.lineBackgroundViewWidth/itemCount) * currentPage,
        y: 0
      )
    })
  }
}

// MARK: - CollectionView DataSource, Delegate

extension HomeMainPagerCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.mainImages.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let cell = collectionView.dequeueCell(
      withType: HomeMainCell.self,
      for: indexPath
    )

    return cell
  }
}
