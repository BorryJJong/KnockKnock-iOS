//
//  StoreListView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/22.
//

import UIKit

import SnapKit
import Then

final class StoreListView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let bannerImageViewTopMargin = 10.f
    static let bannerImageViewLeadingMargin = 20.f
    static let bannerImageViewHeight = 4.f

    static let storeCollectionViewTopMargin = 15.f
  }

  // MARK: - UIs

  private let bannerImageView = UIImageView().then {
    $0.backgroundColor = .orange
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
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
    [self.bannerImageView, self.storeCollectionView].addSubViews(self)

    self.bannerImageView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.bannerImageViewTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.bannerImageViewLeadingMargin)
      $0.height.equalTo(self.bannerImageView.snp.width).dividedBy(Metric.bannerImageViewHeight)
    }

    self.storeCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.bannerImageView.snp.bottom).offset(Metric.storeCollectionViewTopMargin)
      $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
