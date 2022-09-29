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

final class HomeMainPagerCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let lineBackgroundViewWidth = 245.f
    static let lineBackgroundViewHeight = 2.f
    static let lineBackgroundViewLeadingMargin = 20.f
    static let lineBackgroundViewBottomMargin = -30.f

    static let lineViewHeight = 2.f
  }

  // MARK: - Properties

  private var mainImages: [String] = ["", "", "", "", "", ""]
  private var currentIndex: CGFloat = 0

  // MARK: - UIs

  let homeMainCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
    }).then {
      $0.contentInsetAdjustmentBehavior = .never
      $0.alwaysBounceVertical = false
      $0.backgroundColor = .clear
    }

  private let lineView = UIView().then {
    $0.backgroundColor = .white
  }

  private let lineBackgroundView = UIView().then {
    $0.backgroundColor = UIColor(
      red: 255/255,
      green: 255/255,
      blue: 255/255,
      alpha: 0.3
    )
  }

  override func setupConfigure() {
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
      $0.height.equalTo(Metric.lineViewHeight)
    }

    self.lineBackgroundView.snp.makeConstraints {
      $0.leading.equalTo(self.contentView).offset(Metric.lineBackgroundViewLeadingMargin)
      $0.bottom.equalTo(self.contentView).offset(Metric.lineBackgroundViewBottomMargin)
      $0.width.equalTo(Metric.lineBackgroundViewWidth)
      $0.height.equalTo(Metric.lineBackgroundViewHeight)
    }
  }

  private func setHomeMainPagerCollectionViewLayout() -> UICollectionViewCompositionalLayout {
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

    mainSection.visibleItemsInvalidationHandler = ({ (_, point, _) in
      self.currentIndex = round(point.x / UIScreen.main.bounds.width)
      self.movePager(currentPage: self.currentIndex, itemCount: self.mainImages.count)
    })

    let layout = UICollectionViewCompositionalLayout(section: mainSection)

    return layout
  }

  // MARK: - Pager(lineView) width 변화 애니메이션 메소드

  private func movePager(currentPage: CGFloat, itemCount: Int) {
    let itemCount = CGFloat(itemCount)
    let lineViewLength = CGFloat(Metric.lineBackgroundViewWidth / itemCount)
    let updateWidth = ((lineViewLength * currentPage) + lineViewLength)

    self.lineView.snp.updateConstraints {
      $0.width.equalTo(updateWidth)
    }

    UIView.animate(withDuration: 0.5, animations: {
      self.layoutIfNeeded()
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
