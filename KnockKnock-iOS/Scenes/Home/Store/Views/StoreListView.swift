//
//  StoreListView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/22.
//

import UIKit

import KKDSKit
import SnapKit
import Then

final class StoreListView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let bannerImageViewTopMargin = 10.f
    static let bannerImageViewLeadingMargin = 20.f
    static let bannerImageViewHeightRatio = 4.f

    static let storeCollectionViewTopMargin = 15.f
  }

  // MARK: - UIs

  let bannerImageView = UIImageView().then {
    $0.image = KKDS.Image.banner_bar_feed_write
    $0.contentMode = .scaleAspectFill
  }

  let bannerButton = KKDSBannerButton()

  let storeCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
      $0.minimumLineSpacing = 15
    }
  ).then {
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

  private func setupConstraints() {
    [self.bannerImageView, self.bannerButton, self.storeCollectionView].addSubViews(self)

    self.bannerImageView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.bannerImageViewTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.bannerImageViewLeadingMargin)
      $0.height.equalTo(self.bannerImageView.snp.width).dividedBy(Metric.bannerImageViewHeightRatio)
    }

    self.bannerButton.snp.makeConstraints {
      $0.edges.equalTo(self.bannerImageView)
    }

    self.storeCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.bannerButton.snp.bottom).offset(Metric.storeCollectionViewTopMargin)
      $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
