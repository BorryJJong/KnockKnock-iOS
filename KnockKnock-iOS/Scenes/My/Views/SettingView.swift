//
//  SettingView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/05.
//

import UIKit

import SnapKit
import Then

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

  let logoutButton = UIButton().then {
    $0.setTitle("로그아웃", for: .normal)
    $0.layer.borderColor = UIColor.gray40?.cgColor
    $0.layer.borderWidth = 1
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
