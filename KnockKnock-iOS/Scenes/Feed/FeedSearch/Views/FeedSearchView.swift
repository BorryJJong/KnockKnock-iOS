//
//  FeedSearchView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/30.
//

import UIKit

import SnapKit
import KKDSKit
import Then

final class FeedSearchView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let searchTapCollectionViewLeadingMargin = 20.f
    static let searchTapCollectionViewHeight = 40.f

    static let underLineViewTopMargin = 5.f
    static let underLineViewLeadingMargin = 25.f
    static let underLineViewWidth = 25.f
    static let underLineViewHeight = 2.f

    static let separatorLineViewHeight = 1.f

    static let searchResultPageCollectionViewTopMargin = 15.f
  }

  // MARK: - UIs

  let searchTapCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
      $0.minimumLineSpacing = 25
    }
  ).then {
    $0.backgroundColor = .clear
  }

  let underLineView = UIView().then {
    $0.backgroundColor = .green40
  }

  private let separatorLineView = UIView().then {
    $0.backgroundColor = KKDS.Color.gray20
  }

  let searchResultPageCollectionView =  UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
      $0.minimumLineSpacing = 0
    }
  ).then {
    $0.backgroundColor = .clear
  }
  
  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configure

  private func setupConstraints() {
    [self.searchTapCollectionView, self.underLineView, self.separatorLineView, self.searchResultPageCollectionView].addSubViews(self)

    self.searchTapCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.searchTapCollectionViewLeadingMargin)
      $0.height.equalTo(Metric.searchTapCollectionViewHeight)
    }

    self.underLineView.snp.makeConstraints {
      $0.top.equalTo(self.searchTapCollectionView.snp.bottom).offset(Metric.underLineViewTopMargin)
      $0.leading.equalTo(self.searchTapCollectionView.snp.leading)
      $0.width.equalTo(Metric.underLineViewWidth)
      $0.height.equalTo(Metric.underLineViewHeight)
    }

    self.separatorLineView.snp.makeConstraints {
      $0.top.equalTo(self.underLineView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(Metric.separatorLineViewHeight)
    }

    self.searchResultPageCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.separatorLineView.snp.bottom).offset(Metric.searchResultPageCollectionViewTopMargin)
      $0.trailing.leading.equalTo(self)
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
