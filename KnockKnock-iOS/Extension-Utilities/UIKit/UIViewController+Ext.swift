//
//  UIViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/15.
//

import UIKit

extension UIViewController {

  /// 화면을 tap 했을 때 Keyboard가 내려가도록 하는 메소드
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(UIViewController.dismissKeyboard)
    )
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }

  /// Alert View 생성 및 present
  /// - Parameters:
  ///   - content: alert message
  ///   - isCancelActive: 취소 버튼 활성화 유무
  ///   - confirmActionCompletion: 확인 버튼 클릭 이벤트
  func showAlert(
    content: String,
    isCancelActive: Bool = true,
    confirmActionCompletion: (() -> Void)? = nil
  ) {
    let alertViewController = AlertViewController(
      content: content,
      isCancelActive: isCancelActive
    )

    alertViewController.addActionToConfirmButton() {
      alertViewController.dismiss(
        animated: false,
        completion: confirmActionCompletion
      )
    }
    self.present(alertViewController, animated: false, completion: nil)
  }
}
