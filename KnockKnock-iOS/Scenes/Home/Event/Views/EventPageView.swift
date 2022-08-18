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

final class EventPageView: UIView {

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
  )

  let underLineView = UIView().then {
    $0.backgroundColor = .green40
  }

  let seperatorView = UIView().then {
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
    [self.tapCollectionView, self.underLineView, self.seperatorView].addSubViews(self)

    self.tapCollectionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.height.equalTo(40)
    }

    self.underLineView.snp.makeConstraints {
      $0.top.equalTo(self.tapCollectionView.snp.bottom).offset(10)
      $0.leading.equalTo(self.tapCollectionView.snp.leading)
      $0.width.equalTo(70)
      $0.height.equalTo(2)
    }

    self.seperatorView.snp.makeConstraints {
      $0.top.equalTo(self.underLineView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
}
