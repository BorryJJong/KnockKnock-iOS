//
//  File.swift
//  
//
//  Created by Daye on 2022/10/11.
//

import UIKit

public extension KKDS {
  enum Color { }
}

// MARK: Light mode color assets

public extension KKDS.Color {
  static var black: UIColor                 { .load(name: "black")}

  static var gray10: UIColor                { .load(name: "gray10") }
  static var gray20: UIColor                { .load(name: "gray20") }
  static var gray30: UIColor                { .load(name: "gray30") }
  static var gray40: UIColor                { .load(name: "gray40") }
  static var gray50: UIColor                { .load(name: "gray50") }
  static var gray60: UIColor                { .load(name: "gray60") }
  static var gray70: UIColor                { .load(name: "gray70") }
  static var gray80: UIColor                { .load(name: "gray80") }
  static var gray90: UIColor                { .load(name: "gray90") }

  static var green10: UIColor               { .load(name: "green10") }
  static var green20: UIColor               { .load(name: "green20") }
  static var green30: UIColor               { .load(name: "green30") }
  static var green40: UIColor               { .load(name: "green40") }
  static var green50: UIColor               { .load(name: "green50") }
  static var green60: UIColor               { .load(name: "green60") }
}

extension UIColor {
  public static func load(name: String) -> UIColor {
    guard let color = UIColor(named: name, in: KKDS.bundle, compatibleWith: nil) else {
      assert(false, "\(name) 색상 로드 실패")
      return UIColor()
    }
    return color
  }
}
