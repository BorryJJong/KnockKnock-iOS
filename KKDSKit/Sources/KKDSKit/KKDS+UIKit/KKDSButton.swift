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
  static var button_middle: UIButton {
    let button = UIButton()
    button.setTitleColor(UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1), for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
    button.layer.cornerRadius = 3
    
    return button
  }
}
