//
//  LikeDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/10.
//

import UIKit

import SnapKit
import Then

class LikeDetailView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let likeCollectionViewTopMargin = 10.f
    static let likeCollectionViewLeadingMargin = 20.f
  }

  // MARK: - UIs

  let likeCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    }
  )

  // MARK: - initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.likeCollectionView].addSubViews(self)

    self.likeCollectionView.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.likeCollectionViewTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.likeCollectionViewLeadingMargin)
    }
  }

  func likeDetailCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let likeItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(40)
    )
    let likeItem = NSCollectionLayoutItem(layoutSize: likeItemSize)

    let likeGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(40)
    )
    let likeGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: likeGroupSize,
      subitems: [likeItem]
    )

    let likeSection = NSCollectionLayoutSection(group: likeGroup)
    likeSection.interGroupSpacing = 15

    let layout = UICollectionViewCompositionalLayout(section: likeSection)

    return layout
  }
}
