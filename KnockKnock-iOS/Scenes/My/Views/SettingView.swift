//
//  SettingView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

import SnapKit
import Then
import KKDSKit

final class SettingView: UIView {

  // MARK: - UIs

  let settingCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then{
      $0.scrollDirection = .vertical
    }).then {
      $0.backgroundColor = .white
    }

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.settingCollectionView].addSubViews(self)

    self.settingCollectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
