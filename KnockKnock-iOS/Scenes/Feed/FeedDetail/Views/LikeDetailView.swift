//
//  LikeDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/10.
//

import UIKit

import SnapKit
import Then

class LikeDetailView: UIView {

  // MARK: - UIs

  let likeCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
    }
  )

  // MARK: - initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.likeCollectionView].addSubViews(self)

    self.likeCollectionView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
}

