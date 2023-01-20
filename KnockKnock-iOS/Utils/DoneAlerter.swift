//
//  Done.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/19.
//

import UIKit

import Then
import Lottie
import KKDSKit
import SnapKit

final class DoneAlerter {
  private static let shared = DoneAlerter()
  private var backgroundView: UIView?

  static func showLoading() {
    guard let window = UIApplication.shared.windows.last else { return }

    var doneIndicatorView = LottieAnimationView(name: "zero_waste_done")

    let doneHeaderLabel = UILabel().then {
      $0.text = "게시글 등록이 완료되었습니다!"
      $0.font = .systemFont(ofSize: 20, weight: .heavy)
    }

    let doneLabel = UILabel().then {
      $0.text = "또 다른 챌린지에도 도전해보세요."
      $0.font = .systemFont(ofSize: 13, weight: .regular)
      $0.textColor = KKDS.Color.gray70
    }

    if let existedView = window.subviews.first(where: {
      $0 is LottieAnimationView
    }) as? LottieAnimationView {
      doneIndicatorView = existedView
    } else {
      let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.frame = window.frame
      }

      window.backgroundColor = .clear
      window.addSubview(backgroundView)
      window.addSubview(doneIndicatorView)
      window.addSubview(doneHeaderLabel)
      window.addSubview(doneLabel)

      doneLabel.snp.makeConstraints {
        $0.bottom.equalTo(window.snp.centerY).offset(-50)
        $0.centerX.equalTo(window)
      }

      doneHeaderLabel.snp.makeConstraints {
        $0.bottom.equalTo(doneLabel.snp.top).offset(-15)
        $0.centerX.equalTo(window)
      }

      doneIndicatorView.snp.makeConstraints {
        $0.bottom.equalTo(doneHeaderLabel.snp.top).offset(-25)
        $0.centerX.equalTo(window)
        $0.width.height.equalTo(150)
      }

      shared.backgroundView = backgroundView
    }
    doneIndicatorView.contentMode = .scaleAspectFit
    doneIndicatorView.play()
    doneIndicatorView.loopMode = .playOnce
  }

  static func hideLoading() {
    guard let window = UIApplication.shared.windows.last else { return }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      window.subviews.filter({
        $0 is LottieAnimationView ||
        $0 is UILabel
      }).forEach {
        $0.removeFromSuperview()
      }
      shared.backgroundView?.removeFromSuperview()

    }
  }
}
