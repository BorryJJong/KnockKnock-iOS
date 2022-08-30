//
//  TapCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/12.
//

import UIKit

final class TapCell: BaseCollectionViewCell {

  // MARK: - UIs

  let tapLabel = UILabel().then {
    $0.text = "진행 이벤트"
    $0.font = .systemFont(ofSize: 15)
    $0.textColor = .black
  }

  // MARK: - Bind

  func bind(tapName: String) {
    self.tapLabel.text = tapName
  }

  // MARK: - Configure

  override func setupConfigure() {
    [self.tapLabel].addSubViews(self.contentView)

    self.tapLabel.snp.makeConstraints {
      $0.centerX.equalTo(self.contentView.snp.centerX)
      $0.bottom.equalTo(self.contentView.snp.bottom)
    }
  }
}
