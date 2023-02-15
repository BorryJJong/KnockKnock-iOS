//
//  EventDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/15.
//

import UIKit

import KKDSKit
import SnapKit
import Then

final class EventDetailView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let tapCollectionViewLeadingMargin = 20.f
    static let tapCollectionViewHeight = 40.f

    static let underLineViewTopMargin = 10.f
    static let underLineViewWidth = 70.f
    static let underLineViewHeight = 2.f

    static let separatorViewHeight = 1.f
  }

  // MARK: - UIs

  let eventPageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal
  )

  let tapCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
      $0.minimumLineSpacing = 30
    }
  ).then {
    $0.backgroundColor = .clear
  }

  let underLineView = UIView().then {
    $0.backgroundColor = .green40
  }

  private let separatorView = UIView().then {
    $0.backgroundColor = .gray20
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
    [self.tapCollectionView, self.underLineView, self.separatorView, self.eventPageViewController.view].addSubViews(self)

    self.tapCollectionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.tapCollectionViewLeadingMargin)
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.height.equalTo(Metric.tapCollectionViewHeight)
    }

    self.underLineView.snp.makeConstraints {
      $0.top.equalTo(self.tapCollectionView.snp.bottom).offset(Metric.underLineViewTopMargin)
      $0.leading.equalTo(self.tapCollectionView.snp.leading)
      $0.width.equalTo(Metric.underLineViewWidth)
      $0.height.equalTo(Metric.underLineViewHeight)
    }

    self.separatorView.snp.makeConstraints {
      $0.top.equalTo(self.underLineView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(Metric.separatorViewHeight)
    }

    self.eventPageViewController.view.snp.makeConstraints {
      $0.top.equalTo(self.separatorView.snp.bottom)
      $0.leading.bottom.trailing.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
