//
//  EventListView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/19.
//

import UIKit

import SnapKit
import Then

class EventListView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let eventCollectionViewTopMargin = 20.f
  }


  // MARK: - UIs

  let eventCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
      $0.minimumLineSpacing = 20
    }
  )

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
    [self.eventCollectionView].addSubViews(self)

    self.eventCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Metric.eventCollectionViewTopMargin)
      $0.leading.trailing.bottom.equalTo(self)
    }
  }
}
