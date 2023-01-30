//
//  UIImage+Ext.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/07.
//

import UIKit

extension UIImage {
  func resize(newWidth: CGFloat) -> UIImage {
    let scale = newWidth / self.size.width
    let newHeight = self.size.height * scale

    let size = CGSize(width: newWidth, height: newHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { _ in
      self.draw(in: CGRect(origin: .zero, size: size))
    }

    return renderImage
  }

  /// 2개의 이미지가 동일 이미지인지 판별
  func isEqualToImage(image: UIImage?) -> Bool {
    guard let image = image else { return false }

    guard let data1 = self.pngData() as? NSData,
          let data2 = image.pngData() as? NSData else { return false }

    return data1.isEqual(data2)
  }
}
