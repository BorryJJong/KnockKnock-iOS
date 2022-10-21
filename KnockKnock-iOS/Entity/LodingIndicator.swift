//
//  LodingIndicatorView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/10/20.
//

import UIKit

final class LoadingIndicator {
  static func showLoading() {
    DispatchQueue.main.async {
      guard let window = UIApplication.shared.windows.last else { return }

      let loadingIndicatorView: UIActivityIndicatorView

      if let existedView = window.subviews.first(where: {
        $0 is UIActivityIndicatorView
      }) as? UIActivityIndicatorView {
        loadingIndicatorView = existedView
      } else {
        loadingIndicatorView = UIActivityIndicatorView(style: .large)
        loadingIndicatorView.frame = window.frame
        loadingIndicatorView.color = .white

        window.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        window.addSubview(loadingIndicatorView)
      }
      loadingIndicatorView.startAnimating()

      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        LoadingIndicator.hideLoading()
      }
    }
  }

  static func hideLoading() {
    DispatchQueue.main.async {
      guard let window = UIApplication.shared.windows.last else { return }
      window.backgroundColor = .clear
      window.subviews.filter({
        $0 is UIActivityIndicatorView
      }).forEach {
        $0.removeFromSuperview()
      }
    }
  }
}
