//
//  LodingIndicatorView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/20.
//

import UIKit

import Then

final class LoadingIndicator {
  private static let shared = LoadingIndicator()
  private var backgroundView: UIView?

  static func showLoading() {
    guard let window = UIApplication.shared.windows.last else { return }

    let loadingIndicatorView: UIActivityIndicatorView

    if let existedView = window.subviews.first(where: {
      $0 is UIActivityIndicatorView
    }) as? UIActivityIndicatorView {
      loadingIndicatorView = existedView
    } else {
      let backgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        $0.frame = window.frame
      }
      loadingIndicatorView = UIActivityIndicatorView(style: .large)
      loadingIndicatorView.frame = window.frame
      loadingIndicatorView.color = .white

      window.backgroundColor = .clear
      window.addSubview(backgroundView)
      window.addSubview(loadingIndicatorView)

      shared.backgroundView = backgroundView
    }
    loadingIndicatorView.startAnimating()
  }

  static func hideLoading() {
    guard let window = UIApplication.shared.windows.last else { return }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      window.subviews.filter({
        $0 is UIActivityIndicatorView
      }).forEach {
        $0.removeFromSuperview()
      }
      shared.backgroundView?.removeFromSuperview()

    }
  }
}
