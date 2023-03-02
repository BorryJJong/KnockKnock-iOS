//
//  ProfileSettingView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/08.
//

import UIKit

import SnapKit
import KKDSKit
import Then

final class ProfileSettingView: UIView {
  
  // MARK: - Constants
  
  private enum Metric {
    static let profileImageViewTopMargin = 20.f
    static let profileImageViewWidth = 86.f
    
    static let cameraImageViewWidth = 24.f
    static let nicknameTextFieldLeadingMargin = 20.f
    static let nicknameTextFieldTopMargin = 30.f
    static let nicknameTextFiedlHeight = 45.f
    
    static let noticeLabelTopMargin = 10.f
    static let noticeLabelLeadingMargin = 20.f
    
    static let confirmButtonLeadingMargin = 20.f
    static let confirmButtonBottomMargin = -10.f
    static let confirmButtonHeight = 47.f
  }
  
  // MARK: - UIs
  
  private let profileImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_my_img_86
    $0.layer.cornerRadius = 43
    $0.clipsToBounds = true
  }
  
  private let cameraImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_camera_24_gr
  }
  
  let profileButton = UIButton()
  
  let nicknameTextField = UITextField().then {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
    $0.placeholder = "닉네임 입력"
    $0.layer.borderColor = UIColor.gray40?.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 3
    $0.tintColor = .green50
    $0.clearButtonMode = .whileEditing
    $0.leftView = paddingView
    $0.leftViewMode = .always
    $0.autocorrectionType = .no
  }
  
  private let noticeLabel = UILabel().then {
    $0.setLineHeight(
      content: "• 한글, 영문, 숫자, 특수문자로 최대 30자까지 사용 가능해요.\n• 최소 2자 이상 입력해주세요.",
      font: .systemFont(ofSize: 13, weight: .regular)
    )
    $0.numberOfLines = 3
    $0.textColor = .gray50
  }
  
  let confirmButton = UIButton().then {
    $0.setTitle("완료", for: .normal)
    $0.titleLabel?.textColor = .white
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
    $0.layer.cornerRadius = 3
    $0.backgroundColor = .gray40
    $0.isEnabled = false
  }

  // MARK: - Initialize
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Bind

  func setProfileImage(image: UIImage?) {
    self.profileImageView.image = image ?? KKDS.Image.ic_my_img_86
  }

  func setPreviousProfile(userData: UserDetail) {
    self.nicknameTextField.text = userData.nickname

    guard let image = userData.image else {
      self.profileImageView.image = KKDS.Image.ic_my_img_86
      return
    }
    self.profileImageView.image = UIImage(data: image)
  }

  func enableConfirmButton(isEnable: Bool) {
    self.confirmButton.isEnabled = isEnable
    self.confirmButton.backgroundColor = .green50
  }

  // MARK: - Configure
  
  private func setupConstraints() {
    
    [self.profileImageView, self.cameraImageView, self.profileButton, self.nicknameTextField, self.noticeLabel, self.confirmButton].addSubViews(self)
    
    self.profileImageView.snp.makeConstraints {
      $0.centerX.equalTo(self.safeAreaLayoutGuide)
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.profileImageViewTopMargin)
      $0.width.height.equalTo(Metric.profileImageViewWidth)
    }
    
    self.cameraImageView.snp.makeConstraints {
      $0.trailing.equalTo(self.profileImageView.snp.trailing)
      $0.bottom.equalTo(self.profileImageView.snp.bottom)
      $0.width.height.equalTo(Metric.cameraImageViewWidth)
    }
    
    self.profileButton.snp.makeConstraints {
      $0.edges.equalTo(self.profileImageView)
    }
    
    self.nicknameTextField.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.nicknameTextFieldLeadingMargin)
      $0.top.equalTo(self.profileButton.snp.bottom).offset(Metric.nicknameTextFieldTopMargin)
      $0.height.equalTo(Metric.nicknameTextFiedlHeight)
    }
    
    self.noticeLabel.snp.makeConstraints {
      $0.top.equalTo(self.nicknameTextField.snp.bottom).offset(Metric.noticeLabelTopMargin)
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.noticeLabelLeadingMargin)
    }

    self.confirmButton.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.confirmButtonLeadingMargin)
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(Metric.confirmButtonHeight)
      $0.height.equalTo(Metric.confirmButtonHeight)
    }
  }
}
