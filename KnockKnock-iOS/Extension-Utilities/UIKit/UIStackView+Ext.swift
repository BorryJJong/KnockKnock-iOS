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

  func addParticipantImageViews(images: [String?]) async {
    var images = images

    // 참여자가 없을 경우 디폴트 이미지 1개 내려주기 위해서 nil 삽입
    if images.count == 0 {
      images.append(nil)
    }

    for index in 0..<images.count {
      let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        $0.layer.cornerRadius = $0.frame.width / 2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.backgroundColor = .white
        $0.clipsToBounds = true
      }

      do {
        if let stringUrl = images[index],
           let url = URL(string: stringUrl) {

          let (data, _) = try await URLSession.shared.data(from: url)
          let image = UIImage(data: data)
          imageView.image = image?.resizeSquareImage(newWidth: 24)

        } else {
          imageView.image = KKDS.Image.ic_person_24
        }

        addArrangedSubview(imageView)

      } catch {

        imageView.image = KKDS.Image.ic_person_24
        addArrangedSubview(imageView)
      }

      if index == 2 {
        break
      }
    }
  }
}
