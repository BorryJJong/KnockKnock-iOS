//
//  UIImage+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/07.
//

import UIKit

extension UIImage {
  /// 이미지 리사이징(정방형)
  func resizeSquareImage(newWidth: CGFloat) async -> UIImage {
    let newHeight = newWidth

    let size = CGSize(width: newWidth, height: newHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { _ in
      self.draw(in: CGRect(origin: .zero, size: size))
    }

    return renderImage
  }
}
