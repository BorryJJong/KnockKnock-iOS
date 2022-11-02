//
//  ProfileSettingViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/09.
//

import UIKit

import KKDSKit

final class ProfileSettingViewController: BaseViewController<ProfileSettingView> {

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Configure

  override func setupConfigure() {
    let backButton = UIBarButtonItem(
      image: KKDS.Image.ic_back_24_bk,
      style: .done,
      target: self,
      action: #selector(backButtonDidTap(_:))
    )

    self.navigationItem.leftBarButtonItem = backButton
    self.navigationController?.navigationBar.setDefaultAppearance()
    self.navigationItem.title = "프로필 설정"

    self.containerView.nicknameTextField.do {
      $0.delegate = self
      $0.addTarget(
        self,
        action: #selector(self.textFieldDidTap(_:)),
        for: .touchDown
      )
    }
    self.hideKeyboardWhenTappedAround()
  }

  // MARK: - TextField Actions

  @objc private func textFieldDidTap(_ textField: UITextField) {
    self.containerView.bind(isClicked: true)
  }

  // MARK: - Button Actions

  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
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
