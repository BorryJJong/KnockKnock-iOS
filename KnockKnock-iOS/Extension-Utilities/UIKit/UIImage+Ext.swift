//
//  UIImage+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/07.
//

import UIKit

extension UIImage {
  func resize(newWidth: CGFloat) async -> UIImage {
    let scale = newWidth / self.size.width
    let newHeight = self.size.height * scale

    let size = CGSize(width: newWidth, height: newHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { _ in
      self.draw(in: CGRect(origin: .zero, size: size))
    }

    return renderImage
  }
}
