//
//  LodingIndicatorView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/20.
//

import UIKit

import Then
import Lottie

final class LoadingIndicator {
  private static let shared = LoadingIndicator()
  private var backgroundView: UIView?

  static func showLoading() {
    guard let window = UIApplication.shared.windows.last else { return }
    var loadingIndicatorView = LottieAnimationView(name: "zero_waste_loading")

    if let existedView = window.subviews.first(where: {
      $0 is LottieAnimationView
    }) as? LottieAnimationView {
      loadingIndicatorView = existedView
    } else {
      let backgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        $0.frame = window.frame
      }
      loadingIndicatorView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
      loadingIndicatorView.center = window.center

      window.backgroundColor = .clear
      window.addSubview(backgroundView)
      window.addSubview(loadingIndicatorView)

      shared.backgroundView = backgroundView
    }
    loadingIndicatorView.contentMode = .scaleAspectFit
    loadingIndicatorView.play()
    loadingIndicatorView.loopMode = .loop
  }

  static func hideLoading(isDone: Bool? = false) {
    guard let window = UIApplication.shared.windows.last else { return }

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      window.subviews.filter({
        $0 is LottieAnimationView
      }).forEach {
        $0.removeFromSuperview()
      }
      shared.backgroundView?.removeFromSuperview()

    }

  }
}
