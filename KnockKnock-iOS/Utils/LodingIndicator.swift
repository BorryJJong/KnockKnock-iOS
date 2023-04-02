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
  private var showTime: DispatchTime?

  static func showLoading() {
    DispatchQueue.main.async {
      guard let window = UIApplication.shared.windows.last else { return }

      var loadingIndicatorView = LottieAnimationView(name: "zero_waste_loading")

      if let existedView = window.subviews.first(where: {
        $0 is LottieAnimationView
      }) as? LottieAnimationView {
        loadingIndicatorView = existedView
      } else {
        shared.showTime = DispatchTime.now()

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
  }

  static func hideLoading() {
    guard let window = UIApplication.shared.windows.last else { return }

    guard let distance = shared.showTime?.distance(to: DispatchTime.now()).toDouble() else { return }

    if distance > 0.5 {
      DispatchQueue.main.asyncAfter(deadline: .now()) {
        window.subviews.filter({
          $0 is LottieAnimationView
        }).forEach {
          $0.removeFromSuperview()
        }
        shared.backgroundView?.removeFromSuperview()
      }

    } else {

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 - distance) {
        window.subviews.filter({
          $0 is LottieAnimationView
        }).forEach {
          $0.removeFromSuperview()
        }
        shared.backgroundView?.removeFromSuperview()

      }
    }

  }
}
