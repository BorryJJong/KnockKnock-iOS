//
//  KKDSLargeButton.swift
//  
//
//  Created by Daye on 2023/02/04.
//

import UIKit

public final class KKDSLargeButton: KKDSButton {

  override func setupConfigure() {
    self.setTitleColor(
      .white,
      for: .normal
    )
    self.titleLabel?.font = .systemFont(
      ofSize: 15,
      weight: .medium
    )
    self.backgroundColor = KKDS.Color.green50
    self.layer.cornerRadius = 3
  }
}
