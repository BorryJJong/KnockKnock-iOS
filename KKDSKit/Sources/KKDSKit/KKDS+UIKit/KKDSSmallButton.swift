//
//  KKDSMiddleButton.swift
//  
//
//  Created by Daye on 2023/02/13.
//

import UIKit

public final class KKDSSmallButton: KKDSButton {

  override func setupConfigure() {
    self.setTitleColor(
      .white,
      for: .normal
    )
    self.titleLabel?.font = .systemFont(
      ofSize: 12,
      weight: .bold
    )

    self.clipsToBounds = true
    self.layer.cornerRadius = 15

    self.setBackgroundColor(KKDS.Color.green50, for: .normal)
    self.setBackgroundColor(KKDS.Color.gray40, for: .disabled)
  }
}
