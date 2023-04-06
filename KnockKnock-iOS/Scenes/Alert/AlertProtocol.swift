//
//  AlertProtocol.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/03/14.
//

import UIKit

protocol AlertProtocol {
  func showAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

extension AlertProtocol where Self: UIViewController {

  func showAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    let alertViewController = AlertViewController(
      content: message,
      isCancelActive: isCancelActive ?? false
    )
    alertViewController.addActionToConfirmButton(completion: confirmAction)

    self.present(
      alertViewController,
      animated: false,
      completion: nil
    )
  }
}
