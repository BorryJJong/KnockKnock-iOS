//
//  File.swift
//  
//
//  Created by Daye on 2022/10/05.
//

import UIKit

public extension KKDS {
  enum Button { }
}

public extension KKDS.Button {
  static var MiddleButton: UIButton = {
    let button = UIButton()

    button.setTitleColor(
      KKDS.Color.gray80,
      for: .normal
    )
    button.titleLabel?.font = .systemFont(
      ofSize: 13,
      weight: .medium
    )
    button.layer.borderWidth = 1
    button.layer.borderColor = KKDS.Color.gray40.cgColor
    button.layer.cornerRadius = 3

    return button
  }()

  static var LargeButton: UIButton = {
    let button = UIButton()

    button.setTitleColor(
      .white,
      for: .normal
    )
    button.titleLabel?.font = .systemFont(
      ofSize: 15,
      weight: .medium
    )
    button.backgroundColor = KKDS.Color.green50
    button.layer.cornerRadius = 3

    return button
  }()
}
