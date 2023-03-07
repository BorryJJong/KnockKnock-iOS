//
//  KKDSMiddleButton.swift
//  
//
//  Created by Daye on 2023/02/13.
//

import UIKit

public final class KKDSSmallButton: KKDSButton {

  // MARK: - Properties

  private var disabledColor = KKDS.Color.gray40
  private var enabledColor = KKDS.Color.green50

  public override var isEnabled: Bool {
    didSet {
      self.backgroundColor = isEnabled
      ? enabledColor : disabledColor
    }
  }

  // MARK: - Configure

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
  }
}
