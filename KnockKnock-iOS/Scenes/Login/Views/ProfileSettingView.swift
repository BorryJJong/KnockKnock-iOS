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

class ProfileSettingView: UIView {

  // MARK: - UIs

  private let profileImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_my_img_86
    $0.layer.cornerRadius = 43
    $0.clipsToBounds = true
  }

  private let cameraImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_camera_24_gr
  }

  private let profileButton = UIButton()

  private let nicknameTextField = UITextField().then {
    $0.placeholder = "닉네임 입력"
    $0.layer.borderColor = UIColor.green50?.cgColor
    $0.layer.borderWidth = 1
    $0.tintColor = .gray50
    $0.clearButtonMode = .whileEditing
  }

  private let noticeLabel = UILabel().then {
    $0.text = "• 한글, 영문, 숫자, 특수문자로 최대 30자까지 사용 가능해요.\n• 최소 2자 이상 입력해주세요."
    $0.numberOfLines = 2
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray50
  }

  private let confirmButton = UIButton().then {
    $0.setTitle("완료", for: .normal)
    $0.titleLabel?.textColor = .white
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
    $0.layer.cornerRadius = 3
    $0.backgroundColor = .gray40
  }

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configure

  private func setupConstraints() {

    self.profileImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(20)
      $0.width.height.equalTo(86)
    }

    self.cameraImageView.snp.makeConstraints {
      $0.trailing.equalTo(self.profileImageView.snp.trailing)
      $0.bottom.equalTo(self.profileImageView.snp.bottom)
      $0.width.height.equalTo(24)
    }

    self.profileButton.snp.makeConstraints {
      $0.edges.equalTo(self.profileImageView)
    }

    self.nicknameTextField.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.top.equalTo(self.profileButton.snp.bottom).offset(30)
      $0.height.equalTo(45)
    }

    self.confirmButton.snp.makeConstraints {
      $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
      $0.bottom.equalToSuperview().offset(-10)
      $0.height.equalTo(47)
    }

  }
}
