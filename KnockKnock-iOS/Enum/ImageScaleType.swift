//
//  ImageScale.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/04.
//

import UIKit

enum ImageScaleType: String {
  case square = "1:1"
  case threeToFour = "3:4"
  case fourToThree = "4:3"

  func cellSize(width: CGFloat) -> CGSize {
    switch self {
    case .threeToFour:
      return CGSize(
        width: (width - 40),
        height: ((width - 40) * 1.333 + 170))

    case .fourToThree:
      return CGSize(
        width: (width - 40),
        height: ((width - 40) * 0.75 + 170))

    case .square:
      return CGSize(
        width: (width - 40),
        height: ((width - 40) + 170))
    }
  }

  func imageSize(xPosition: CGFloat, width: CGFloat) -> CGRect {
    switch self {
    case .threeToFour:
      return CGRect(
        x: xPosition,
        y: 0,
        width: width,
        height: width * 1.333
      )
    case .fourToThree:
      return CGRect(
        x: xPosition,
        y: 0,
        width: width,
        height: width * 0.75
      )
    case .square:
      return CGRect(
        x: xPosition,
        y: 0,
        width: width,
        height: width
      )
    }
  }
}
