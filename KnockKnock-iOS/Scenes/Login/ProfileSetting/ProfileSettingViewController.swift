//
//  ProfileSettingViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/09.
//

import UIKit

import KKDSKit
import Then

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

  var selectedImage: UIImage = KKDS.Image.ic_my_img_86

  lazy var imagePicker = UIImagePickerController().then {
    $0.sourceType = .photoLibrary
    $0.allowsEditing = true
    $0.delegate = self
  }

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

    self.containerView.profileButton.do {
      $0.addTarget(
        self,
        action: #selector(self.profileButtonDidTap(_:)),
        for: .touchUpInside
      )
    }

    self.containerView.confirmButton.do {
      $0.addTarget(
        self,
        action: #selector(self.confirmButtonDidTap(_:)),
        for: .touchUpInside
      )
    }

    self.addKeyboardNotification()
    self.hideKeyboardWhenTappedAround()
  }

  // MARK: - Keyboard Show & Hide

  private func addKeyboardNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc private func keyboardWillShow(_ notification: Notification) {
    self.setContainerViewConstant(notification: notification, isAppearing: true)
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    self.setContainerViewConstant(notification: notification, isAppearing: false)
  }

  private func setContainerViewConstant(notification: Notification, isAppearing: Bool) {
    let userInfo = notification.userInfo

    if let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardSize = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardSize.height

      guard let animationDurationValue = userInfo?[
        UIResponder
          .keyboardAnimationDurationUserInfoKey
      ] as? NSNumber else { return }

      let viewHeightConstant = isAppearing ? (keyboardHeight + 30) : 50

      UIView.animate(withDuration: animationDurationValue.doubleValue) {
        self.containerView.confirmButton.snp.updateConstraints {
          $0.top.equalTo(self.containerView.safeAreaLayoutGuide.snp.bottom).inset(viewHeightConstant)
        }
        self.containerView.layoutIfNeeded()
      }
    }
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

  @objc private func profileButtonDidTap(_ sender: UIButton) {
    self.present(self.imagePicker, animated: true)
  }

  @objc private func confirmButtonDidTap(_ sender: UIButton) {
    let nickname = self.containerView.nicknameTextField.text ?? ""

    self.interactor?.requestSignUp(
      nickname: nickname,
      image: self.selectedImage
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

// MARK: - ImagePicker Delegate

extension ProfileSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {

    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      self.selectedImage = editedImage
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      self.selectedImage = originalImage
    }

    self.containerView.setProfileImage(image: self.selectedImage)

    picker.dismiss(animated: true, completion: nil)
  }
}
