//
//  StoreListView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/22.
//

import UIKit

import SnapKit
import KKDSKit
import Then


class StoreListView: UIView {

  // MARK: - UIs

  let bannerImageView = UIImageView().then {
    $0.backgroundColor = .orange
  }

  let storeCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
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
    [self.bannerImageView, self.storeCollectionView].addSubViews(self)

    self.bannerImageView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
      $0.height.equalTo((self.frame.width - 40)/4)
    }

    self.storeCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.snp.top)
      $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }

}
