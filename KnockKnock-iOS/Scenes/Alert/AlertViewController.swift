//
//  AlertViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/08.
//

import UIKit

final class AlertViewController: BaseViewController<AlertView> {

  // MARK: - Initialize

  convenience init(
    content: String,
    isCancelActive: Bool
  ) {
    self.init()

    self.containerView.bind(
      content: content,
      isCancelActive: isCancelActive
    )
    self.modalPresentationStyle = .overFullScreen
  }

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configure()
  }

  // MARK: - Configure

  private func configure() {
    self.containerView.backgroundColor = .black.withAlphaComponent(0.5)

    self.containerView.cancelButton.addAction(for: .touchUpInside) { _ in
      self.dismiss(animated: false)
    }
  }

  func addActionToConfirmButton(completion: (() -> Void)? = nil) {
    self.containerView.confirmButton.addAction(for: .touchUpInside) { _ in
      if let completion = completion {
        completion()
      } else {
        self.dismiss(animated: false)
      }
    }
  }
}
