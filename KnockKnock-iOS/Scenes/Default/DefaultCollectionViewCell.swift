//
//  DefaultCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/04.
//

import UIKit

import SnapKit
import Then

final class DefaultCollectionViewCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let alertLabel = UILabel().then {
    $0.text = "Error Occurred."
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.alertLabel].addSubViews(self.contentView)

    self.alertLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
}
