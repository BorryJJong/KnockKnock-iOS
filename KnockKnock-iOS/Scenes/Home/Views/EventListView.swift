//
//  EventListVIew.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/12.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class EventListView: UIView {

  // MARK: - UIs

  let eventPageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal
  )

  let tapCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    })

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
    [self.tapCollectionView].addSubViews(self)

    self.tapCollectionView.snp.makeConstraints {
      $0.leading.top.trailing.equalToSuperview()
      $0.height.equalTo(40)
    }
  }
}
