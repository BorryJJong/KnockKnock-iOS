//
//  BottomSheetViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then

class BottomSheetViewController: BaseViewController<BottomSheetView> {

  // MARK: - UI

  override func viewDidLoad() {
    super.viewDidLoad()
    self.containerView.backgroundColor = .clear
    self.containerView.dimmedView.do {
      let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
      $0.addGestureRecognizer(dimmedTap)
      $0.isUserInteractionEnabled = true
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showBottomSheet()
  }

  @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
    self.hideBottomSheet()
  }

  func showBottomSheet() {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.containerView.bottomSheetView.heightAnchor.constraint(equalToConstant: 150).isActive = true
      self.containerView.dimmedView.alpha = 0.7
      self.containerView.layoutIfNeeded()
    }, completion: nil)
  }

  func hideBottomSheet() {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.containerView.bottomSheetView.heightAnchor.constraint(equalToConstant: 0).isActive = true
      self.containerView.dimmedView.alpha = 0.0
      self.containerView.layoutIfNeeded()
    }) { _ in
      if self.presentingViewController != nil {
        self.dismiss(animated: false, completion: nil)
      }
    }
  }
}
