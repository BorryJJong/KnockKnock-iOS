//
//  File.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/07.
//

import UIKit

import KKDSKit
import Then

extension UIStackView {

  func removeAllSubViews() {
    subviews.forEach{
      $0.removeFromSuperview()
    }
  }

  func addParticipantImageViews(images: [String?]) {
    var images = images

    if images.count == 0 {
      images.append("")
    }

    for index in 0..<images.count {
      let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.backgroundColor = .white

        $0.image = images[index]
          .flatMap { URL(string: $0) }
          .flatMap { try? Data(contentsOf: $0) }
          .flatMap { UIImage(data: $0) }
        ?? KKDS.Image.ic_person_24
      }
      addArrangedSubview(imageView)

      if index == 2 {
        break
      }
    }
  }
}
