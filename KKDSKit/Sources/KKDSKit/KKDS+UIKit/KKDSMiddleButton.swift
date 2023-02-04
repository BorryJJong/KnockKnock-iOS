//
//  KKDSMiddleButton.swift
//  
//
//  Created by Daye on 2023/02/04.
//

import UIKit

public final class KKDSMiddleButton: KKDSButton {

  override func setupConfigure() {
    self.setTitleColor(
      KKDS.Color.gray80,
      for: .normal
    )
    self.titleLabel?.font = .systemFont(
      ofSize: 13,
      weight: .medium
    )
    self.layer.borderWidth = 1
    self.layer.borderColor = KKDS.Color.gray40.cgColor
    self.layer.cornerRadius = 3
  }
}
