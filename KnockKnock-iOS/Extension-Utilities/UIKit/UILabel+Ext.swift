//
//  UILabel+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import UIKit

import Then

extension UILabel {

  func setBulletPoint(string: String, font: UIFont) {
    let paragraphStyle = NSMutableParagraphStyle().then {
      $0.headIndent = 15
      $0.minimumLineHeight = 18
      $0.tabStops = [
        NSTextTab(
          textAlignment: .left,
          location: 15
        )
      ]
    }
    
    let stringAttributes = [
      NSAttributedString.Key.font: font,
      NSAttributedString.Key.foregroundColor: UIColor.black,
      NSAttributedString.Key.paragraphStyle: paragraphStyle
    ]

    let string = "•\t\(string)"

    attributedText = NSAttributedString(
      string: string,
      attributes: stringAttributes
    )
  }

  // MARK: Line height 설정

  func setLineHeight(content: String, font: UIFont) {
    let style = NSMutableParagraphStyle()
    let lineHeight = font.pointSize * 1.6
    style.minimumLineHeight = lineHeight
    style.maximumLineHeight = lineHeight

    self.attributedText = NSAttributedString(
      string: content,
      attributes: [
        .paragraphStyle: style,
        .font: font
      ]
    )
  }
}
