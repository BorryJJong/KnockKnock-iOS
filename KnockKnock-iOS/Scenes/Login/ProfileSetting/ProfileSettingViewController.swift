//
//  ProfileSettingViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/09.
//

import UIKit

import KKDSKit

protocol ProfileSettingViewProtocol: AnyObject {
  var interactor: ProfileSettingInteractorProtocol? { get set }
}

final class ProfileSettingViewController: BaseViewController<ProfileSettingView> {

  private enum Nickname {
    static let maxLength = 30
    static let minLength = 2
  }

  // MARK: - Properties

  var interactor: ProfileSettingInteractorProtocol?

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
      $0.addTarget(
        self,
        action: #selector(self.textFieldDidChange(_:)),
        for: .allEditingEvents
      )
    }
    self.containerView.confirmButton.do {
      $0.addTarget(
        self,
        action: #selector(self.confirmButtonDidTap(_:)),
        for: .touchUpInside
      )
    }

    self.hideKeyboardWhenTappedAround()
  }

  // MARK: - TextField Actions

  @objc private func textFieldDidChange(_ textField: UITextField) {
    guard let text = textField.text else { return }

    if text.count >= Nickname.minLength && text.count < Nickname.maxLength {
      textField.layer.borderColor = UIColor.green50?.cgColor
      self.containerView.confirmButton.backgroundColor = .green50
      self.containerView.confirmButton.isEnabled = true
    } else {
      textField.layer.borderColor = UIColor.gray30?.cgColor
      self.containerView.confirmButton.backgroundColor = .gray40
      self.containerView.confirmButton.isEnabled = false
    }

    // 최대 글자 수 초과시 입력 제한
    if text.count >= Nickname.maxLength {
      let index = text.index(text.startIndex, offsetBy: Nickname.maxLength)
      let newString = text[text.startIndex..<index]
      textField.text = String(newString)
    }
  }

  // MARK: - Button Actions

  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.interactor?.navigateToMyView()
  }

  @objc private func confirmButtonDidTap(_ sender: UIButton) {
    let nickname = self.containerView.nicknameTextField.text ?? ""

    self.interactor?.requestSignUp(
      nickname: nickname,
      image: ""
    )

    self.showAlert(
      content: Alert.profileSetting.message,
      confirmActionCompletion: {
        self.interactor?.navigateToMyView()
      }
    )
  }
}

// MARK: - Profile Setting View Protocol

extension ProfileSettingViewController: ProfileSettingViewProtocol {
  
}
