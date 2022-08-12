//
//  TapCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/12.
//

import UIKit

final class TapCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let tapLabel = UILabel().then {
    $0.text = "진행 이벤트"
  }

  // MARK: - Configure

  override func setupConfigure() {
    [self.tapLabel].addSubViews(self.contentView)

    self.tapLabel.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }
  }
}
