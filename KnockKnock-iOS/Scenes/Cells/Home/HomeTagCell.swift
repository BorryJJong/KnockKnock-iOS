//
//  HomeMainTagCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/08.
//

import UIKit

import SnapKit
import KKDSKit
import Then

class HomeTagCell: BaseCollectionViewCell {
  
  // MARK: - UIs
  
  let homeTagCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
    }).then {
      $0.alwaysBounceVertical = false
      $0.contentInsetAdjustmentBehavior = .never
    }
  
  private let gradientImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_tag_gradient_40_wh
  }
  
  override func setupCollectionView() {
    self.homeTagCollectionView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.registCell(type: TagCell.self)
      $0.collectionViewLayout = self.HomeTagCollectionViewLayout()
    }
  }
  
  // MARK: - Constraints
  
  override func setupConstraints() {
    [self.homeTagCollectionView, self.gradientImageView].addSubViews(self.contentView)
    
    self.homeTagCollectionView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }
    
    self.gradientImageView.snp.makeConstraints {
      $0.bottom.trailing.top.equalTo(self.contentView)
    }
  }
  
  private func HomeTagCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    
    let tagEstimatedWidth: CGFloat = 50
    let tagEstimatedHeight: CGFloat = 30
    
    let tagItemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(tagEstimatedWidth),
      heightDimension: .estimated(tagEstimatedHeight)
    )
    let tagItem = NSCollectionLayoutItem(layoutSize: tagItemSize)
    
    let tagGroupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(tagEstimatedWidth),
      heightDimension: .estimated(tagEstimatedHeight)
    )
    
    let tagGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: tagGroupSize,
      subitems: [tagItem]
    )
    
    let tagSection = NSCollectionLayoutSection(group: tagGroup)
    tagSection.interGroupSpacing = 10
    
    tagSection.orthogonalScrollingBehavior = .continuous
    
    let layout = UICollectionViewCompositionalLayout(section: tagSection)
    
    return layout
  }
  
}

extension HomeTagCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 6
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(withType: TagCell.self, for: indexPath)
    
    return cell
  }
}
