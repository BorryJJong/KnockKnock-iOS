//
//  HomeView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/23.
//

import UIKit

import Then
import KKDSKit
import SnapKit

final class HomeView: UIView {

  // MARK: - UIs

  private let homeCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    }
  ).then {
    $0.contentInsetAdjustmentBehavior = .never
    $0.backgroundColor = .clear
  }

  // MARK: - Initailize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Configure

  func configureHomeCollectionView(viewController: HomeViewController) {
    self.homeCollectionView.do {
      $0.dataSource = viewController
      $0.delegate = viewController

      $0.registHeaderView(type: HomeHeaderCollectionReusableView.self)
      $0.registCell(type: HomeMainPagerCell.self)
      $0.registCell(type: StoreCell.self)
      $0.registCell(type: BannerCell.self)
      $0.registCell(type: TagCell.self)
      $0.registCell(type: PopularPostCell.self)
      $0.registFooterView(type: PopularFooterCollectionReusableView.self)
      $0.registCell(type: EventCell.self)

      $0.collectionViewLayout = self.mainCollectionViewLayout()
    }
  }

  func reloadHomeCollectionViewSection(section: HomeSection) {
    UIView.performWithoutAnimation {
      self.homeCollectionView.reloadSections([section.rawValue])
    }
  }

  func scrollToItem(
    index: IndexPath,
    scrollPosition: UICollectionView.ScrollPosition,
    animated: Bool
  ) {
    UIView.performWithoutAnimation {
      self.homeCollectionView.scrollToItem(
        at: index,
        at: scrollPosition,
        animated: animated
      )
    }
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.homeCollectionView].addSubViews(self)

    self.homeCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.snp.top)
      $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
