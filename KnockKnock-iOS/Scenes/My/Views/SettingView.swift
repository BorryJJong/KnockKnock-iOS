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
      let config =  UICollectionLayoutListConfiguration(appearance: .grouped)
      $0.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
      $0.backgroundColor = .white
    }

  let logoutButton = KKDS.Button.button_middle.then {
    $0.setTitle("로그아웃", for: .normal)
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
    [self.settingCollectionView, self.logoutButton].addSubViews(self)

    self.settingCollectionView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.logoutButton.snp.top).offset(-30)
    }

    self.logoutButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-60)
      $0.height.equalTo(40)
      $0.width.equalToSuperview().inset(20)
    }
  }
}
