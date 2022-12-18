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


public final class MiddleButton: UIButton {

  public init(title: String) {
    super.init(frame: .zero)
    configure(title: title)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure(title: String) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(
      UIColor(
        red: 85/255,
        green: 85/255,
        blue: 85/255,
        alpha: 1
      ),
      for: .normal
    )
    self.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
    
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor(
      red: 211/255,
      green: 211/255,
      blue: 211/255,
      alpha: 1)
    .cgColor
    self.layer.cornerRadius = 3
  }
}
