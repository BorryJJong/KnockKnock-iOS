//
//  KKDSMoreButton.swift
//  
//
//  Created by Daye on 2023/03/03.
//

import UIKit

public final class KKDSMoreButton: KKDSButton {

  override func setupConfigure() {
    self.setTitle(
      "더보기",
      for: .normal
    )
    self.titleLabel?.font = .systemFont(
      ofSize: 13,
      weight: .light
    )
    self.setTitleColor(
      KKDS.Color.gray80,
      for: .normal
    )

    self.setImage(
      KKDS.Image.ic_left_10_gr,
      for: .normal
    )
    self.semanticContentAttribute = .forceRightToLeft
  }
}
