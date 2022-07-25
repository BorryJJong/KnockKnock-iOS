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
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
