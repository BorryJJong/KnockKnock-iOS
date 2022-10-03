//
//  ProfileSettingViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/09.
//

import UIKit

final class ProfileSettingViewController: BaseViewController<ProfileSettingView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Configure

  override func setupConfigure() {
    self.containerView.nicknameTextField.do {
      $0.delegate = self
    }
    self.hideKeyboardWhenTappedAround()
  }
}

  // MARK: - TextField delegate

extension ProfileSettingViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.hasText {
      textField.layer.borderColor = UIColor.green50?.cgColor
      self.containerView.confirmButton.backgroundColor = .green50
    } else {
      textField.layer.borderColor = UIColor.gray30?.cgColor
      self.containerView.confirmButton.backgroundColor = .gray40
    }
  }
}
