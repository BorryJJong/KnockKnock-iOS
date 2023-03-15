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
    static let bannerButtonTopMargin = 10.f
    static let bannerButtonLeadingMargin = 20.f
    static let bannerButtonHeight = 4.f

    static let storeCollectionViewTopMargin = 15.f
  }

  // MARK: - UIs

  let bannerButton = KKDSBannerButton().then {
    $0.setImage(KKDS.Image.banner_bar_feed_write, for: .normal)
  }

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
    [self.bannerButton, self.storeCollectionView].addSubViews(self)

    self.bannerButton.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.bannerImageViewTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.bannerImageViewLeadingMargin)
      $0.height.equalTo(self.bannerButton.snp.width).dividedBy(Metric.bannerImageViewHeight)
    }

    self.storeCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.bannerButton.snp.bottom).offset(Metric.storeCollectionViewTopMargin)
      $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
